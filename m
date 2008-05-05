Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbYEEOUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbYEEOUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYEEOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:20:37 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:52740 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753140AbYEEOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:20:36 -0400
Message-ID: <481F17D1.3050701@seznam.cz>
Date: Mon, 05 May 2008 16:21:05 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 21/56] microblaze_v2: setup.c - system setting
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>	 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>	 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>	 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>	 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>	 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>	 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>	 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>	 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>	 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu> <1209953738.5798.63.camel@localhost>
In-Reply-To: <1209953738.5798.63.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXED


>> +++ b/arch/microblaze/kernel/setup.c
> 
>> +#ifdef CONFIG_HACK
>> +	printk(KERN_NOTICE "HACK function enable\n");
>> +#else
>> +	printk(KERN_NOTICE "HACK function disable\n");
>> +#endif
> 
> %s/HACK/something sensible/g
> 
> 
> 
> 
> 
