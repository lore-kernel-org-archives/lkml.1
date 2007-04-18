Return-Path: <linux-kernel-owner+w=401wt.eu-S2992659AbXDROjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659AbXDROjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992669AbXDROjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:39:41 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:40755 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992659AbXDROjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:39:40 -0400
Message-ID: <46262D98.5010609@free.fr>
Date: Wed, 18 Apr 2007 16:39:20 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Shewmaker <agshew@gmail.com>
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de>	 <462603E0.3050208@free.fr> <f4050c9e0704180706m513dd780v79f30f0029fe74de@mail.gmail.com>
In-Reply-To: <f4050c9e0704180706m513dd780v79f30f0029fe74de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Shewmaker wrote:

> John Sigler wrote:
>
>> Andi Kleen wrote:
>>
>>> There are usually chipset specific bits that can be set to disable
>>> SMMs. See the datasheet if you can get them. Unfortunately most
>>> chipset vendors don't give out data sheets easily.
>>
>> I managed to find the south bridge data sheet.
>>
>> http://linux.kernel.free.fr/VT82C686B.pdf
>>
>> (I'm still looking for the north bridge data sheet.)
>>
>> Could someone point me in the right direction?
> 
> The LinuxBIOS folks had a thread on SMM recently.  You don't have to
> worry about SMM if you can use their stuff.

Unfortunately, LinuxBIOS is not a viable option at this point.
I have to live with this proprietary BIOS.

Phoenix AwardBIOS v6.00PG
EBC-2000 REV: A1.3
02/12/2004-694X-686-6A6LJXA9C-00

Regards.
