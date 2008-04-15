Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbYDONcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbYDONcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYDONbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:31:52 -0400
Received: from service1.sh.cvut.cz ([147.32.127.214]:46450 "EHLO
	service1.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYDONbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:31:51 -0400
X-Greylist: delayed 2022 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 09:31:51 EDT
X-Spam-Score: -102.13
Message-ID: <4804A6AA.5070605@seznam.cz>
Date: Tue, 15 Apr 2008 14:59:22 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       John Williams <john.williams@petalogix.com>, benh@kernel.crashing.org,
       John Linn <linnj@xilinx.com>, git-dev <git-dev@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <20080413101304.308f6c1a@zod.rchland.ibm.com> <4802560D.3020308@seznam.cz> <20080414155554.5B8CD98059@mail51-sin.bigfish.com>
In-Reply-To: <20080414155554.5B8CD98059@mail51-sin.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

>> Hi Josh,
>>
>>>> Hi Everybody,
>>>>
>>>> I fixed all reported bugs which I got from LKML and from you.
>>>> Latest version of Microblaze Linux kernel is available at
> git.monstr.eu.
>>>> There is git repository called linux-microblaze.git
>>>> Microblaze port is based on 2.6.24-rc5. I'll create the new repo
> with clean pack
>>>> of changes based on latest kernel version for easier pull.
>>>>
>>>> Merge windows will be open hopefully next week and I would like to
> send pull
>>>> request to Paul.
>>> Why Paul?  If microblaze is a new architecture (which it seems to
> be),
>>> then you should really work through Linus directly.
>> I don't know who start with it. For me is not this point important.
>> I think that was Steve's idea, wasn't it?
> 
> Nope, it should go through Linus.  My hope was to recruit reviewers from
> the powerpc community, since there is alot of overlap (device trees,
> drivers, the MMU is very similar).
> 
> Steve

That can be my mistake.	I don't remember who was it. It doesn't matter.

We talked about recruits with Steve that was different topic not this.

Regards,
Michal Simek
www.monstr.eu


