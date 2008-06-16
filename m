Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYFPBLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYFPBLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYFPBLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:11:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYFPBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:11:44 -0400
Date: Sun, 15 Jun 2008 18:11:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
Message-Id: <20080615181100.79e48697.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806151606320.5736@anakin>
References: <Pine.LNX.4.64.0712161148340.5869@anakin>
	<20071218030131.8b272833.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712182051050.24841@anakin>
	<20071218123119.54262974.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712231142190.24252@anakin>
	<Pine.LNX.4.64.0806151606320.5736@anakin>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2008 16:07:45 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Sun, 23 Dec 2007, Geert Uytterhoeven wrote:
> > New version below. Tested on Amiga. Compile-tested on ia32 (i386_defconfig) and
> > pp64 (ps3_defconfig).
> 
> Ping?

You appear to have a six month RTT ;)

If this was not a mistaken email and if you have something which needs
to be in 2.6.26 then please send it to Linus directly - I'm hiding from
you guys for a week.

Thanks.
