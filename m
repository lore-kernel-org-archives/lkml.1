Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYF0QRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYF0QRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYF0QRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:17:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48789 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604AbYF0QRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:17:23 -0400
Date: Fri, 27 Jun 2008 16:59:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080627165937.2f1fb661@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
References: <20080627154340.GC18957@cvg>
	<Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 16:54:19 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
> 
> > +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
> > +on x86 SMP boxes.
> 
>  While you are at it: s/is/was/.

Erm - why ??

It is still true today that kernels < 2.4.2-ac8 have the NMI oopser
enabled.

Alan
