<template>
    <div>
        <form>
            <div class="relative pb-4">
                <label for="name" class="text-blue-500 pt-2 uppercase text-xs font-bold absolute">Contact Name</label>
                <input type="text" id="name" class="pt-8 w-full text-gray-900 border-b pb-2 focus:outline-none focus:border-blue-400" placeholder="Contact Name">
            </div>
            
            <div class="flex justify-end">
                <button class="py-2 px-4 rounded text-red-700 border mr-5 hover:border-red-700">Cancel</button>
                <button class="bg-blue-500 py-2 px-4 text-white rounded hover:bg-blue-400">Add New Contact</button>
            </div>
        </form>
    </div>
</template>

<script>
    export default {
        name:"ContactsCreate"
    };
</script>