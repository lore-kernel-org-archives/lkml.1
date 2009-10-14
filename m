Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbZJNWFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbZJNWFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZJNWFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:05:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:37804 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771AbZJNWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:05:08 -0400
Date: Wed, 14 Oct 2009 18:04:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: System (motherboard/CPU?) emits high pitch noise when processor.ko
 is loaded.
In-Reply-To: <20091014210558.GA15555@rhlx01.hs-esslingen.de>
Message-ID: <alpine.DEB.2.00.0910141803380.2653@p34.internal.lan>
References: <20091014210558.GA15555@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Andreas Mohr wrote:

> And that's news exactly how? ;)
> Systems and their switching regulators (and especially their backing
> coils) have been making noise for more than half a decade now,
> depending on which activities frequency is currently taking place
> on the system.
>
> OTOH this means that in your case, maybe some interval in the processor module
> (or somewhere related) is ill-chosen (leading to significant, audible differences
> between busy/idle state) and should be changed.
>
> For example, with HZ settings 100 can cause quite a bit of noise on some
> machines, whereas 1000 is better, IIRC. And that could be similar for some
> processing in this module.
>
> Andreas
>

Hi,

Ok, well I never had that happen before when loading that module-- 
although I never normally ran it except for testing purposes, so it was news
to me :)

CPU was i870 & mobo = DP55KG for reference and I use a HZ setting of 1000.

Justin.
