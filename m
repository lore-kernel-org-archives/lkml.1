Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXFOBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXFOBry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXFOBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:47:47 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39391 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXFOBrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:47:46 -0400
Date: Fri, 15 Jun 2007 10:46:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kaz Kojima <kkojima@rr.iij4u.or.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull for 2.6.22-rc4 - resend] kbuild: fix sh64 section mismatch problems
Message-ID: <20070615014618.GA28164@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kaz Kojima <kkojima@rr.iij4u.or.jp>,
	LKML <linux-kernel@vger.kernel.org>
References: <20070611195552.GB7238@uranus.ravnborg.org> <20070613061507.GB20648@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613061507.GB20648@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 08:15:07AM +0200, Sam Ravnborg wrote:
> Resend of the below pull request.
> 
> 	Sam
> 
> On Mon, Jun 11, 2007 at 09:55:52PM +0200, Sam Ravnborg wrote:
> > Hi Linus.
> > 
> > Please apply following 2 liners fix.
> > It will fix a lot of false section mismatch warnings on sh64 and
> > Paul asked to have in included before the relase hit the street.
> > 
> > Please pull this single patch from:
> > 	git://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git
> > 
And another re-request.
