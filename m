Return-Path: <linux-kernel-owner+w=401wt.eu-S934985AbZLGKJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbZLGKJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934942AbZLGKJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:09:23 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:2158 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941AbZLGKJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:09:23 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B1CD457.3060801@tremplin-utc.net>
Date: Mon, 07 Dec 2009 11:09:27 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
Cc: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Subject: [OT] Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>	 <4B055609.9030306@tremplin-utc.net>	 <4B1A53AE.9020707@tremplin-utc.net>	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>	 <4B1BDAA3.10601@gentoo.org>	 <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>	 <4B1C38B5.2060204@tremplin-utc.net>	 <40a4ed590912070143j231e07b6uafd04d0f2ee15dca@mail.gmail.com>	 <4B1CD029.3080503@tremplin-utc.net> <40a4ed590912070202q30852e2fo35023f557919966e@mail.gmail.com>
In-Reply-To: <40a4ed590912070202q30852e2fo35023f557919966e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-12-09 11:02, Zeno Davatz schreef:
:
> Not the same on Gentoo. I think I have to find the kernel boot-option
> that I can pass to lilo.
> 
> Also: When I force remove the modules psb and drm_psb with "rmmod -f"
> and then start X I get the same error:
> 
> X: symbol lookup error: /usr/lib/xorg/modules/drivers/psb_drv.so:
> undefined symbol: LoaderRefSymLists
> 
> X just does not yet like psb.
You are also aware that it does not work on Xserver 1.7, right? 1.6 is
the the maximum.

See you
Eric
