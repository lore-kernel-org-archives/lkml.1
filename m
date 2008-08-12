Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYHLNUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYHLNUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYHLNUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:20:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52893 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYHLNUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:20:35 -0400
Date: Tue, 12 Aug 2008 16:18:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
Message-ID: <20080812131850.GE13910@cs181140183.pp.htv.fi>
References: <489E0F5A.8010404@keyaccess.nl> <20080812125840.GA13910@cs181140183.pp.htv.fi> <48A18C2C.3030009@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48A18C2C.3030009@keyaccess.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:12:12PM +0200, Rene Herman wrote:
> On 12-08-08 14:58, Adrian Bunk wrote:
>
>> On Sat, Aug 09, 2008 at 11:42:50PM +0200, Rene Herman wrote:
>
>>> I'm going over a list of drivers that break the boot of randconfig   
>>> kernels by keeping resources busy:
>>> ...
>>
>> WTF?
>>
>> You are expecting randconfig kernels to boot?
>
> 90% does it seems. Ingo has been using it as part of automated testing  
> for some time now.

Please define "boot".

E.g. for your harddisk driver alone the probability of not having it 
included in a randconfig kernel is definitely > 10%.

Same goes for the network driver.

...

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

