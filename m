Return-Path: <linux-kernel-owner+w=401wt.eu-S1765398AbXGVVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765398AbXGVVBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764282AbXGVVBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:01:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36305 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764749AbXGVVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:01:05 -0400
Date: Sun, 22 Jul 2007 23:01:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
In-Reply-To: <6101e8c40707221345gc24ed3o5ef3d379b85b400e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707222300270.32367@fbirervta.pbzchgretzou.qr>
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com> 
 <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com> 
 <Pine.LNX.4.64.0707222235130.32367@fbirervta.pbzchgretzou.qr>
 <6101e8c40707221345gc24ed3o5ef3d379b85b400e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 22:45, Oliver Pinter wrote:
>>
>> But why move the config entry?
>
> I thinked, sorted the items by time-line:
> the old sort im Kconfig is i386..Pentium{I,II,III}..Core2..Pentium4
> and the time line is    93 .. 95-99 .. 2006 .. 2001
>
> and the new sort is:
> ... Pentium4 .. Core2
>
> as the CPU-s manufactured.

Ah yes, good idea.

[ Then again, I could ask, why not sort in reverse so that for the most recent
CPU, you do not have to scroll down on an evergrowing list... ]


	Jan
-- 
