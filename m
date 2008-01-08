Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYAHSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYAHSLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYAHSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:11:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50294 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYAHSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:11:20 -0500
Date: Tue, 8 Jan 2008 19:11:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tuomo Valkonen <tuomov@iki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
Message-ID: <Pine.LNX.4.64.0801081907130.3032@fbirervta.pbzchgretzou.qr>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
 <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8 2008 17:52, Tuomo Valkonen wrote:
>On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
>> Use tune2fs to deactivate checking.
>
>So, a workaround is the answer to a clear bug. Typical FOSS.

Well if it is a problem for you, why do not you come and fix it?

>> Modify the init scripts or use another distro.
>
>Another typical FOSS answer. "You have the source, you can fix it."
>With what time?

If you do not like spending time yourself, hire someone.

>> Check your tool-chain. Many people compile recent kernels with no problems.
>
>And recompile and recompile and recompile ad infinitum, because always
>some option was missing or wrong, there being far too many of them and
>hidden all over the place.

Yes. Either you compile or you use a distro kernel. But you do not want
either, so that kinda narrows it down.

>> Nobody forces you to use udev. Moreover, you can write your own udev
>> rules that match your expectations.
>
>See above on having time to learn over-cryptic systems.

http://linux.oneandoneis2.org/LNW.htm . Replace Windows by <whatever
favorite OS you wanted to originally have>.

>> You're not ranting about Linux but about your Distro. Complain on
>> the corresponding distro-specific mailing list, use another distro
>> and and stop whining.
>
>I don't use a distro kernel. I use a kernel I compiled myself over
>two years ago. I have tried compiling newer ones, but it's too much
>work to get all the options right. And then there's the problem that
>the "good" driver for my SATA disk may not be there anymore in the
>latest kernels, and so on.

I did the same previously. As soon as there was more than three
machines to administer, I stopped building kernels the typical way
for production machines and instead built one central RPM (sort of
distro kernel). I never look back.
