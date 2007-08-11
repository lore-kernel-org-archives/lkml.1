Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXHKLfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXHKLfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 07:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbXHKLfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 07:35:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51657 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbXHKLfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 07:35:00 -0400
Date: Sat, 11 Aug 2007 13:35:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
Message-ID: <20070811113545.GB11651@uranus.ravnborg.org>
References: <20070811025802.GA15885@Krystal> <1186825800.32314.2.camel@localhost> <20070811095658.GA11651@uranus.ravnborg.org> <1186829697.3930.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186829697.3930.4.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 12:54:57PM +0200, Martin Schwidefsky wrote:
> On Sat, 2007-08-11 at 11:56 +0200, Sam Ravnborg wrote:
> > > That attached patch should fix it for arm and mips. I'll try a few more
> > > architectures until I'm fed up with compiling cross-compilers..
> > http://userweb.kernel.org/~akpm/cross-compilers/
> 
> Thanks for the hint but I prefer to compile them on my own (naming
> scheme, installation target, 4.1.2, ..). The first one is the hardest,
> for the following ones it is just a matter how fast you machine is.
> I'll do one cross-compiler every 15 minutes right now (without glibc).
Should dive into this myself one day.
But for now crosstool has saved my day.

	Sam
