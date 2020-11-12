# build server
FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine as build

WORKDIR /src

COPY LevelUpDevOps.csproj .
RUN dotnet restore

COPY . .
RUN dotnet build -c Release
RUN dotnet test
RUN dotnet publish -c Release /dist


# production server
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

COPY --from=build /dist .

CMD ["dotnet", "LevelUpDevOps.dll"]
