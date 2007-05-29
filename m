Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbXE2Tct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbXE2Tct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXE2Tcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:32:42 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36110 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXE2Tcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:32:41 -0400
Date: Tue, 29 May 2007 15:32:38 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel chipset
Message-ID: <20070529193238.GF6815@fieldses.org>
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org> <465C5C16.7020001@rtr.ca> <29495f1d0705291006o1f812ce2n25fa962c222e0b45@mail.gmail.com> <alpine.LFD.0.98.0705291044220.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705291044220.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 10:47:06AM -0700, Linus Torvalds wrote:
> On Tue, 29 May 2007, Nish Aravamudan wrote:
> > The man-page is pretty good. There used to be
> > http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt,
> > but it's 404 now...
> 
> That file got folded into the user manual, so it doesn't exist as a 
> stand-alone thing any more.

Yup, see
	http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#using-bisect

which also has a pointer to the man page.

--b.
