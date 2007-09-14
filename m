Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbXINVKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbXINVKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXINVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:10:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33720 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbXINVKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:10:15 -0400
Date: Fri, 14 Sep 2007 23:11:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Shlomi Fish <shlomif@freehackers.org>
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement (rev8)
Message-ID: <20070914211140.GB5031@uranus.ravnborg.org>
References: <200709141645.04112.shlomif@freehackers.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141645.04112.shlomif@freehackers.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shlomi Fish.

> [ I'm not subscribed to this list so please CC me on your replies. ]
We always do so at lkml..

> This patch adds an option to use either substring match, regular expression 
> match, or keywords search in the "make xconfig" Edit->Find dialog.
> 
> It also allows searching on the "help" field of the menus as well as 
> the "name" of the symbol.
> 
> This change involved adding the sym_generic_search function to the LKC, and 
> implementing sym_re_search using it.
> 
Thanks for being persistent on this.
Unless I hear otherwise from Roman I plan to apply your patch during the weekend.

	Sam
