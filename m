Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbXIPJXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbXIPJXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 05:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXIPJXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 05:23:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38398 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXIPJXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 05:23:40 -0400
Date: Sun, 16 Sep 2007 11:25:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Shlomi Fish <shlomif@freehackers.org>
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement (rev8)
Message-ID: <20070916092505.GB6543@uranus.ravnborg.org>
References: <200709141645.04112.shlomif@freehackers.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709141645.04112.shlomif@freehackers.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 04:45:03PM +0300, Shlomi Fish wrote:
> Hi all!
> 
> [ I'm not subscribed to this list so please CC me on your replies. ]
> 
> This patch adds an option to use either substring match, regular expression 
> match, or keywords search in the "make xconfig" Edit->Find dialog.
> 
> It also allows searching on the "help" field of the menus as well as 
> the "name" of the symbol.
> 
> This change involved adding the sym_generic_search function to the LKC, and 
> implementing sym_re_search using it.

I fixed up the line breake in the patch and applied it.
Please add a signed-off-by next time.

Thanks,
	Sam
