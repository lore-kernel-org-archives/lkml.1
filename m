Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbZAMIxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbZAMIxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZAMIxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:53:07 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:63910 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbZAMIxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:53:05 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUNIjI/PLwx
Message-ID: <496C5669.4040407@hartkopp.net>
Date: Tue, 13 Jan 2009 09:52:57 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: David Miller <davem@davemloft.net>, joe.tian.kernel@gmail.com,
       lizf@cn.fujitsu.com, qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: fix wrong English expression in comments
References: <496a3c51.09876e0a.03fe.7e80@mx.google.com>	<496A9753.80802@cn.fujitsu.com>	<6b1ba94c0901122336r511fa316o5f520a8d2d9d6e0@mail.gmail.com> <20090112.234441.131571840.davem@davemloft.net> <496C4987.8040803@cosmosbay.com>
In-Reply-To: <496C4987.8040803@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> David Miller a écrit :
>   
>> From: joe tian <joe.tian.kernel@gmail.com>
>> Date: Tue, 13 Jan 2009 15:36:51 +0800
>>
>>     
>>> 2009/1/12 Li Zefan <lizf@cn.fujitsu.com>:
>>>       
>>>>> @@ -103,7 +103,7 @@ struct inet_bind_bucket;
>>>>>  struct inet_timewait_sock {
>>>>>       /*
>>>>>        * Now struct sock also uses sock_common, so please just
>>>>> -      * don't add nothing before this first member (__tw_common) --acme
>>>>> +      * don't add anything before this first member (__tw_common) --acme
>>>>>           
>>>> They are the same meaning...
>>>>
>>>>         
>>> I don't think they are the same meaning.
>>> I think "don't add anything" means "do add nothing" but not means "don't add
>>> nothing"
>>>       
>> No offense to anyone, but the only people arguing for "correctness"
>> seem to be non-native speakers of English.  Is this correct? :-)
>>
>> As Ben tries to explain, "don't add nothing" is a colloquialism of
>> English that in fact can mean "do not add"
>>
>> It sounds amusing when read, and I'm not killing the character and
>> personality of this comment just for some language lawyering.
>>
>> No way.
>>     
>
> Oh my God... time for me to check what is a colloquialism :)
>
>
> According to wikipedia :
>
> A colloquialism is an expression not used in formal speech, 
> writing or paralinguistics. Colloquialisms are also sometimes 
> referred to collectively as "colloquial language". [1] Colloquialisms
> or colloquial language is considered to be characteristic of or only
> appropriate for casual, ordinary, familiar, or informal conversation
> rather than formal speech or writing.

So the Linux Kernels comments are only for native speakers of English 
that are familiar with these colloquialisms?

I also would have to think longer about the current comment than i would 
have to on the patched one.

When we reduce parentheses and have coding style definitions to make the 
reading of source code easy and fast - why don't we fix these 
colloquialisms that are confusing non-native English speakers?

I personally would vote for this particular patch - but i assume 
thousands of these patches might jam the mailing lists then :-(

Regards,
Oliver

