Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXIAThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXIAThU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXIAThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:37:09 -0400
Received: from iona.labri.fr ([147.210.8.143]:60942 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbXIAThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:37:07 -0400
Date: Sat, 1 Sep 2007 21:36:52 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901193652.GD12644@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dtor@mail.ru
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz> <20070901122604.GA3251@implementation.famille.thibault.fr> <20070901123258.GA4612@ucw.cz> <20070901125120.GC3251@implementation.famille.thibault.fr> <20070901172301.GA4275@ucw.cz> <20070901173329.GB12644@implementation> <20070901181845.GA4839@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070901181845.GA4839@ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Sat 01 Sep 2007 18:18:45 +0000, a écrit :
> > > > Very early is not so early, and loading initrd itself may actually fail.
> > > > The kernel may indeed hang, but there are more chances to get some
> > > > messages before the hang.  Don't _you_ have a VGA screen for getting
> > > > earliest failure messages from the kernel?
> > > 
> > > No. I'm using framebuffer, that's initialized quite late in boot
> > > process. Plus many users just use bootsplash. I do use vga mode for
> > > heavy debugging, but that's quite unusual.
> > 
> > But that's what some people do for their work, so they need it.
> 
> How many such users are out there?

You know that it's a question that just can't be answered.  There are
such people, and their employment depend on this.

> > > So... you actually have speech-enabled grub/lilo/something?
> > 
> > That's in project too (and there's no reason it shouldn't be done).
> 
> I'd say kernel debugging is hard without accessible bootloader

A bootloader with only two entries is not so difficult to use blindly.

Samuel
