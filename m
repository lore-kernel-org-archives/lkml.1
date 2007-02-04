Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbXBDUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbXBDUCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXBDUCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:02:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:35066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbXBDUCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=gaz2Gt2E23hCsT0ETM/W1+4gdFkm8MzVTXRAH3mXKpDe4rys5D1b/pyD74U1YT1db/XQ+pvAzm6BwkLUjkA3T0acpsgZPudcY3a7ZeSdXhPg2jbLjkFYrXn0d/Xbw0sZv8XsFlyN2K1FUgOvoO+6GePv1ZzezjxIBs24LgcKaBM=
Message-ID: <45C63BD2.3040007@web.de>
Date: Sun, 04 Feb 2007 21:02:26 +0100
From: Markus Wenke <M.Wenke@web.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Try to fill route cache
References: <45C08EA6.9070504@web.de> <p73irekogce.fsf@bingen.suse.de> <45C35670.6060406@web.de> <200702021718.43021.dada1@cosmosbay.com>
In-Reply-To: <200702021718.43021.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet schrieb:
> On Friday 02 February 2007 16:19, Markus Wenke wrote:
>   
>> Andi Kleen schrieb:
>>     
>>> Markus Wenke <M.Wenke@web.de> writes:
>>>       
>>>> Where is the problem ?
>>>>         
>>> pktgen doesn't use the routing cache.
>>>       
>> Is there any other chance to test my Application with a stressed route
>> cache?
>>
>>     
>
> I am not sure I understood your stress environment.
> Do you use several machines ?
> If yes, then the route cache of the destination machine should be filled...
>
>   
I stress my server from ca. 7 machines.
Every machine runs some test-programms, every testprogram stress the 
server with some threads.

I use only 7 real machines, so my route cache ist not stressed or?


thanks in advanced


Markus Wenke


