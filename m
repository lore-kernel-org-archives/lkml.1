Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbXHKJzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbXHKJzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbXHKJzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:55:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43463 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbXHKJzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:55:41 -0400
Date: Sat, 11 Aug 2007 11:56:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
Message-ID: <20070811095658.GA11651@uranus.ravnborg.org>
References: <20070811025802.GA15885@Krystal> <1186825800.32314.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186825800.32314.2.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 11:50:00AM +0200, Martin Schwidefsky wrote:
> On Fri, 2007-08-10 at 22:58 -0400, Mathieu Desnoyers wrote:
> > I got the following errors when building 2.6.23-rc2-mm2 on both mips and
> > arm. Both errors are very much alike.
> 
> That attached patch should fix it for arm and mips. I'll try a few more
> architectures until I'm fed up with compiling cross-compilers..
http://userweb.kernel.org/~akpm/cross-compilers/

	Sam
