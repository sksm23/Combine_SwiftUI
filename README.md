# Project Name: Combine_SwiftUI

1. Used MVVM Architechture to Maintain code base in a efficiant way, so that it can be easily scalable in future.

2. Written Buisiness logic ViewModel and sending required data to View. We can have one intermediate UseCase class in between NetworkManager and ViewModel and inject UseCase as dependecy to ViewModel, hence we can seggregate the code.

3. Used #Combine Framework to make an asynchronous API call to fetch required data, Implemented NetworkManager using Combine and URLSession, tried to implement 'NetworkManager' as generic as possible for this Test(we can scale it in future as per fetures and functionalities).

4. Done UI using SwiftUI, which is more effective and recommended by Apple.

5. Used Protocols on ViewModel functions So that I dont have to depend on ViewModel to write Unit tests can mock data easily using protocols.
