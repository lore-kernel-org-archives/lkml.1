Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXKLRUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXKLRUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXKLRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:19:55 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50964
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXKLRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:19:54 -0500
Date: Mon, 12 Nov 2007 09:30:06 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Adrian Bunk <bunk@kernel.org>
cc: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [poll] Is the megafreeze development model broken?
In-Reply-To: <20071112171456.GN9771@stusta.de>
Message-ID: <Pine.LNX.4.64.0711120926580.23845@asgard.lang.hm>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com>
 <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de>
 <47387BB5.4090908@smsglobal.net> <20071112171456.GN9771@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Adrian Bunk wrote:

> Date: Mon, 12 Nov 2007 18:14:57 +0100
> From: Adrian Bunk <bunk@kernel.org>
> To: Rogelio M. Serrano Jr. <rogelio@smsglobal.net>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Subject: Re: [poll] Is the megafreeze development model broken?
> 
> On Tue, Nov 13, 2007 at 12:13:41AM +0800, Rogelio M. Serrano Jr. wrote:
>> Adrian Bunk wrote:
>>>
>> Isn't the kernel easier to sync with latest and greatest?
>>
>> The core libc and supporting libraries is the core. and the toolchain
>> the core dev. Those can be updated twice or even once a year. The kernel
>> can be updated once a month if you like.
>
> A new release of the Linux kernel has more than half a million lines of
> code changed. If you do any estimates based on how many lines of changed
> code equal one newly introduced bug you see the problem...
>
> And the difference between an upstream kernel and a distribution kernel
> are 3-6 months of testing and bugfixing.

this is very true. the big question is which side of the fork has more 
testing and bugfixes? the distro with their paid developers, or the 
kernel.org kernel with the input from many different distros and the rest 
of the community.

David Lang
