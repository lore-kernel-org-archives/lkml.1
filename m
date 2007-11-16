Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbXKPHYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbXKPHYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXKPHYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:24:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36644 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXKPHYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:24:10 -0500
Date: Thu, 15 Nov 2007 23:15:27 -0800
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken
	in 2.6.23.1)
Message-ID: <20071116071527.GE31582@kroah.com>
References: <200711032351.52977.rob@landley.net> <20071115210608.GA12213@kroah.com> <20071116030832.GB2563@hacking> <200711152301.44040.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711152301.44040.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:01:43PM -0600, Rob Landley wrote:
> On Thursday 15 November 2007 21:08:32 WANG Cong wrote:
> > On Thu, Nov 15, 2007 at 01:06:08PM -0800, Greg KH wrote:
> > >Hm, not good.  I'll let Jeff handle this :)
> >
> > Could you please try this patch? Can it fix the error?
> >
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> Oh what a good idea.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

Heh, we came full circle here, this was Rob's original patch :)

Rob, I'll queue this up for the next cycle, now that you've verified
that it was not fixed already, thanks for testing.

greg k-h
