Return-Path: <linux-kernel-owner+w=401wt.eu-S966382AbXEVQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966382AbXEVQKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXEVQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:10:24 -0400
Received: from [81.2.110.250] ([81.2.110.250]:49002 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757092AbXEVQKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:10:23 -0400
Date: Tue, 22 May 2007 17:14:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Message-ID: <20070522171436.5b9f4440@the-village.bc.nu>
In-Reply-To: <9e4733910705220902y151d1922s7e478de041062aa4@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	<20070522155439.20bf509f@the-village.bc.nu>
	<9e4733910705220816j778e00ecle86e209ef0111b8e@mail.gmail.com>
	<200705220846.53664.jbarnes@virtuousgeek.org>
	<9e4733910705220902y151d1922s7e478de041062aa4@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've talked to an ATI engineer about VBIOS initialization. The chips
> may have different steppings. 

ATI won't even tell us how to do 2D mode setting or clear the code under
NDA that does so. So we don't support AMD (aka ATI) video hardware
anyway. Until they grow up its an irrelevant case.

The problem is how to support the hardware of people who will work sanely
with the free software community and how to do it well.  If it makes life
worse for those who don't then that is their problem.

Alan
