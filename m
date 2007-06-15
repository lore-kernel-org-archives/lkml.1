Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbXFOB7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbXFOB7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXFOB7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:59:04 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45205 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXFOB7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:59:01 -0400
Date: Fri, 15 Jun 2007 10:57:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Kaz Kojima <kkojima@rr.iij4u.or.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull for 2.6.22-rc4 - resend] kbuild: fix sh64 section mismatch problems
Message-ID: <20070615015735.GA28189@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kaz Kojima <kkojima@rr.iij4u.or.jp>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070611195552.GB7238@uranus.ravnborg.org> <20070613061507.GB20648@uranus.ravnborg.org> <20070615014618.GA28164@linux-sh.org> <alpine.LFD.0.98.0706141853050.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706141853050.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 06:53:40PM -0700, Linus Torvalds wrote:
> On Fri, 15 Jun 2007, Paul Mundt wrote:
> > > > 
> > > > Please pull this single patch from:
> > > > 	git://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git
> > > > 
> > And another re-request.
> 
> I get irritated when people send me multiple requests with bogus URL's.
> 
> At least get the URL right.
> 
> 		Linus

Oops, that should be:

	master.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fix.git
