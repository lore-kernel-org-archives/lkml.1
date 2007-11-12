Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbXKLCsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbXKLCsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 21:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXKLCsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 21:48:14 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3641 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXKLCsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 21:48:14 -0500
Date: Mon, 12 Nov 2007 03:47:02 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility
 ARCH={i386,x86_64} for x86
In-Reply-To: <20071110204038.GA13140@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0711120344310.1818@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 10 Nov 2007, Sam Ravnborg wrote:

> As discussed in another thread the right thing is to add a generic solution
> to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.

Could you please point me to this discussion?
Thanks.

bye, Roman
