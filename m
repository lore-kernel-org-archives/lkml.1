Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXBECQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXBECQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXBECQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:16:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:51773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXBECQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:16:56 -0500
Subject: Re: [Cbe-oss-dev] [PATCH 0/7] RFC: Cell SPE logos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       James Simmons <jsimmons@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <20070204133212.GA2032@elf.ucw.cz>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
	 <20070204133212.GA2032@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 13:14:11 +1100
Message-Id: <1170641652.2620.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 14:32 +0100, Pavel Machek wrote:
> Hi1
> 
> > I would like to hear your opinions about the patchset below (updated version
> > compared to yesterday, lkml added to the CC list).
> 
> Can you just blast these pictures from userspace? There's really no
> excuse to advertise SPEs from kernel....
> 
> What's next, I have powerful Intel graphics chipset in here, perhaps
> it is as powerful as SPE, shall I start adding little pictures for its
> pipelines?

By the same token, there is no excuse to have the logo code at all in
the kernel in the first place... it's cool though :-) And it's a config
option, so you don't have to have it....

Ben


