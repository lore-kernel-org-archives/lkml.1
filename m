Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYBQWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYBQWge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYBQWgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:36:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35536 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbYBQWgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:36:14 -0500
Date: Sun, 17 Feb 2008 23:36:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: setup_usemap() must be __meminit
Message-ID: <20080217223623.GA16053@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0802171317230.10451@anakin> <Pine.LNX.4.64.0802171329400.6172@anakin> <20080217194320.GL14588@uranus.ravnborg.org> <Pine.LNX.4.64.0802172138010.6172@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802172138010.6172@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > I would need a config where the mismatch triggers for one
> > of the more popular architectures (as in where I have a toolchain).
> 
> That was with plain m68k defconfig.
> 
> > I could not reproduce it with x86 64bit - not even with -fno-inline-functions
> 
> If it helps, my cross-compiler is gcc version 4.1.2 20061115 (prerelease)
> (Debian 4.1.1-21).

I could build a m68k toolchin using crosstool.
I will take a look one of the next days - too late now.

	Sam
