Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbXBDRoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbXBDRoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXBDRoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:44:09 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35991 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471AbXBDRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:44:07 -0500
Date: Sun, 4 Feb 2007 18:44:00 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
cc: James Simmons <jsimmons@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 0/7] RFC: Cell SPE logos
In-Reply-To: <20070204133212.GA2032@elf.ucw.cz>
Message-ID: <Pine.LNX.4.62.0702041842070.13690@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
 <20070204133212.GA2032@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Pavel Machek wrote:
> > I would like to hear your opinions about the patchset below (updated version
> > compared to yesterday, lkml added to the CC list).
> 
> Can you just blast these pictures from userspace? There's really no
> excuse to advertise SPEs from kernel....

Everything drawn on a frame buffer (penguin logos, text console, ...) can
indeed be done from userspace.

> What's next, I have powerful Intel graphics chipset in here, perhaps
> it is as powerful as SPE, shall I start adding little pictures for its
> pipelines?

Do you have in-kernel support for running generic code on those pipelines?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
