Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXLFKYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXLFKYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXLFKYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:24:30 -0500
Received: from mout1.freenet.de ([195.4.92.91]:53919 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbXLFKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:24:29 -0500
Message-ID: <4757CDD4.5090606@de.ibm.com>
Date: Thu, 06 Dec 2007 11:24:20 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: carsteno@de.ibm.com, Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com> <20071205233345.GB5617@wotan.suse.de> <4757B62F.2040608@de.ibm.com> <20071206085223.GA25202@wotan.suse.de> <4757C7E6.7050405@de.ibm.com> <20071206101848.GC25202@wotan.suse.de>
In-Reply-To: <20071206101848.GC25202@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> OK, thanks for taking a look at that. It will be helpful for testing
> XIP with my new ramdisk driver (did you see the patch?).
I have'nt looked at it yet. I do appreciate it, I think it might 
broaden the user-base of this feature which is up to now s390 only due 
to the fact that the flash memory extensions have not been implemented 
(yet?). And it enables testing xip on other platforms. The patch is on 
my must-read list.

> Actually another one's recently sprung up too (arch/powerpc/sysdev/axonram.c)
> but it looks like that one should be fine as it looks to be all simply memory
> mapped.
Oh I know, the author's office is aproximately 500 meters away from 
mine, next building. I have'nt heared of anyone actually using that 
one lately.

cheers,
Carsten
