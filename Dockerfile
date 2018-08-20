FROM microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY test.csproj .
RUN dotnet restore

# copy everything else and build
COPY . .

RUN dotnet publish -c Release -o ./out  test.csproj

# Build runtime image
FROM microsoft/dotnet:2.1.2-aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "test.dll"]