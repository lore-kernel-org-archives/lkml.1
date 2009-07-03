Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZGCDen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZGCDen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 23:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZGCDee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 23:34:34 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:58294 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZGCDee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 23:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P2ZR6d4H6/bgUX7dOKRRM8enuRSmlEF1ehY4UnD6liJLdPgXPnw8Oy3dRUsLy5T7dj
         w52JY/69WA82joZiFNDH4FhTjz29bl7R9G1zFwhwu/Eug+Ta1ILQe4xZGYspjE5Nr1VU
         yeyakYw3LGyKo8ks6wsW1T4urOs/Uc3LQW7GI=
Message-ID: <4A4D7C94.2020307@gmail.com>
Date: Thu, 02 Jul 2009 20:35:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] SElinux: Fix some typos.
References: <1246556775-8942-1-git-send-email-justinmattock@gmail.com> <1246556775-8942-2-git-send-email-justinmattock@gmail.com> <alpine.LRH.2.00.0907030850500.10242@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0907030850500.10242@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 2 Jul 2009, Justin P. Mattock wrote:
>
>    
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> Fix some typos in some comments.
>>      
>
>    
>> -/* The file system's label must be initialized prior to use. */
>> +/* The filesystems label must be initialized prior to use. */
>>      
>
> Your adding grammertical error's.
>
>    
well, after figuring out how to have git send -email functioning correctly,
I needed something to send.      : ^ )
(but after doing a quick google filesystem did show up).
>> -	 * Note that the setting of hard limits (even to lower them) can be
>> +	 * Note: That the setting of hard limits (even to lower them) can be
>>      
>
> Please get this patch reviewed by an English speaker.
>
>    
That seems viable to me.
>>    * Description:
>>    * Call the NetLabel mechanism to get the security attributes of the given
>> - * packet and use those attributes to determine the correct context/SID to
>> - * assign to the packet.  Returns zero on success, negative values on failure.
>> + * packet and use those attributes to determine the correct context/SID to be
>> + * assigned to the packet.  Returns zero on success, negative values on failure.
>>      
>
> Eschew the active voice?
>
>
> - James
>    
wast ist das?
No I will not be afraid of submitting patches, and having them be rejected.
all part of the learning curve.

Justin P. Mattock
