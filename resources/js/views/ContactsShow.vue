<template>
    <div>
        <div v-if="loading">Loading...</div>
        
        <div v-else>
            <div class="flex justify-between">
                <div class="text-blue-400">
                    < Back 
                </div>
                
                <div>
                    <router-link :to="'/contacts/' + contact.contact_id + '/edit'" class="px-4 py-2 rounded text-sm font-bold text-green-500 border border-green-500 mr-2">Edit</router-link>
                    <a href="#" class="px-4 py-2 border border-red-500 rounded text-sm font-bold text-red-500">Delete</a>
                </div>
            </div>
            
            <div class="flex items-center pt-6">
                <UserCircle :name="contact.name" />
                
                <p class="pl-5 text-xl">{{ contact.name }}</p>
            </div>
            
            <p class="pt-6 text-gray-600 font-bold uppercase text-sm">Contact</p>
            <p class="pt-2 text-blue-400">{{ contact.email }}</p>
            
            <p class="pt-6 text-gray-600 font-bold uppercase text-sm">Company</p>
            <p class="pt-2 text-blue-400">{{ contact.company }}</p>
            
            <p class="pt-6 text-gray-600 font-bold uppercase text-sm">Birthday</p>
            <p class="pt-2 text-blue-400">{{ contact.birthday }}</p>
        </div>
        
        
    </div>
</template>

<script>
    import UserCircle from '../components/UserCircle';
    export default {
        name: "ContactsShow",
        
        components: {
            UserCircle,  
        },
        
        mounted() {
            axios.get('/api/contacts/' + this.$route.params.id)
                .then(response => {
                    this.contact = response.data.data;
                    
                    this.loading = false;
                })
                .catch(error => {
                    this.loading = false;
                });
        },
        
        data: function() {
            return {
                loading: true,
                contact: null,
            };
        }
    };
</script>

<style scoped>
    
</style>