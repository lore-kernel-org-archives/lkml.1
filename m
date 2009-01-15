Return-Path: <linux-kernel-owner+w=401wt.eu-S1765462AbZAOOZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765462AbZAOOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbZAOOZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:25:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50691 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758923AbZAOOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:25:46 -0500
Date: Thu, 15 Jan 2009 14:25:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090115142541.5a7711b1@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
References: <20090108120338.6b8b4567@zonk.pl>
	<alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
	<1231424025.11687.447.camel@twins>
	<alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz>
	<1231424833.11687.452.camel@twins>
	<20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
	<20090108151046.GK18120@elte.hu>
	<alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org>
	<20090115123614.GR11087@lug-owl.de>
	<alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org>
	<20090115133252.28c36adb@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> userland support with little burden for both Linux and respective user 
> software maintainers.  Certainly it adds some bloat to the kernel, but I 
> think it is not an option that should be outright dismissed without 
> consideration.

Nobody normally builds for 386 (and you need the big FPU emulator etc too
and pay a big penalty for the lack of working WP bits) so it wouldn't be
a big penalty if you can actually find an i386 user any more ;)

