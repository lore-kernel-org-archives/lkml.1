Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYBLI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYBLI4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbYBLI4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:56:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57900 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762118AbYBLIz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:55:59 -0500
Date: Tue, 12 Feb 2008 09:56:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: fix make V=1
Message-ID: <20080212085605.GB26865@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080211133137.GB20959@uranus.ravnborg.org> <20080211164709.GA22359@uranus.ravnborg.org> <E1JOiEG-0000do-0W@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JOiEG-0000do-0W@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:38:24AM +0100, Oleg Verych wrote:
> * Date: Mon, 11 Feb 2008 17:47:09 +0100
> []
> > Mike spotted another missing thing from his initial
> > patch so I folded it into the fix and pushed out
> > a new kbuild.git tree.
> >
> > See updated patch below.
> >
> > 	Sam
> 
> Sam, do you agree my fix was more reliable (yea, not only efficient:)?
You more or less just reverted the original patch - so it was obviously
more reliable than introducing new stuff as the fix did.
But we are at -r1 so I prefer to get the inteded behaviour
and not the minmal fix.

	Sam
