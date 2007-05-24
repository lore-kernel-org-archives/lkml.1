Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbXEXUm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbXEXUm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbXEXUmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:42:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXEXUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:42:21 -0400
Date: Thu, 24 May 2007 13:40:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       rmk@arm.linux.kernel.org, spyro@f2s.com, <starvik@axis.com>,
       <ysato@users.sourceforge.jp>, "Luck, Tony" <tony.luck@intel.com>,
       <takata@linux-m32r.org>, chris@zankel.net, <uclinux-v850@lsi.nec.co.jp>,
       kyle@parisc-linux.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
Message-Id: <20070524134015.e89843db.akpm@linux-foundation.org>
In-Reply-To: <20070523205645.07b03581@the-village.bc.nu>
References: <20070523174446.37abfa7a@the-village.bc.nu>
	<Pine.LNX.4.64.0705232117260.10610@anakin>
	<20070523205645.07b03581@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, I'm all dazed and confused about these patches:

arm-enable-arbitary-speed-tty-ioctls-and-split.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch

are there any interdependencies here, or can the various patches
go into the various trees in random order without ill effects?

Thanks.
