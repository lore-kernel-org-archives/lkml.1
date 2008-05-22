Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYEVTUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYEVTUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYEVTTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:19:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34970 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbYEVTTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:19:54 -0400
Date: Thu, 22 May 2008 22:17:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080522191733.GF2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com> <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <48359DE1.8050600@s5r6.in-berlin.de> <20080522170956.GC2727@cs181133002.pp.htv.fi> <4835B144.4000101@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4835B144.4000101@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:45:40PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
>> On Thu, May 22, 2008 at 06:22:57PM +0200, Stefan Richter wrote:
>>> Adrian Bunk wrote:
>>>> And ALSA alone has 2000 open bug reports, which makes the open ACPI 
>>>> or SCSI bug numbers relatively irrelevant in any "number of bugs"  
>>>> statistics.
>>> Central facilities like ACPI and SCSI having relatively few [and
>>> according to Arjan a decreasing number of] reported unfixed bugs is...
>>> irrelevant?
>>
>> Yes, _in any "number of bugs" statistics_ that is irrelevant.
>
> Well, yes, in any "simplistic total number of bugs without any frame of  
> reference what is actually counted" statistics it is indeed irrelevant.

But this kind of statistics is the only one we could realistically ever 
get.

There is no simple and correct way to e.g. say whether some ACPI bug is 
more or less bad than some ALSA bug or which of them might affect more 
people.

> [...]
>> We do not even have good data for "number of bug reports".
>
> That's right.  We don't have comprehensive data, and it is difficult to  
> draw conclusions from the data that we have.
> 
> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

