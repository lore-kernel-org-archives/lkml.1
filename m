Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbYEGXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbYEGXC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYEGXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbYEGXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:02:06 -0400
Message-ID: <482234BD.3080005@zytor.com>
Date: Wed, 07 May 2008 16:01:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Pavel Machek <pavel@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl>	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	 <20080507124650.GD29935@cs181133002.pp.htv.fi>	 <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>	 <20080507212343.GB14951@cs181133002.pp.htv.fi>	 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>	 <20080507221435.GH18516@elf.ucw.cz> <86802c440805071523u2d858727l2fc6d9edbd30cad8@mail.gmail.com>
In-Reply-To: <86802c440805071523u2d858727l2fc6d9edbd30cad8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>  2) HPA said it was bad idea
> 
> hpa said white list is not a good idea.

I did, but I conceded that it is a reasonable intermediate step.

If the whitelist is there a year from now it's a problem.

	-hpa
