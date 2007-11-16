Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbXKPSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbXKPSAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761036AbXKPSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:00:35 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42250
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbXKPSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:00:34 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Date: Fri, 16 Nov 2007 12:00:25 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
References: <200711032351.52977.rob@landley.net> <200711152301.44040.rob@landley.net> <20071116071527.GE31582@kroah.com>
In-Reply-To: <20071116071527.GE31582@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161200.26619.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 01:15:27 Greg KH wrote:
> On Thu, Nov 15, 2007 at 11:01:43PM -0600, Rob Landley wrote:
> > On Thursday 15 November 2007 21:08:32 WANG Cong wrote:
> > > On Thu, Nov 15, 2007 at 01:06:08PM -0800, Greg KH wrote:
> > > >Hm, not good.  I'll let Jeff handle this :)
> > >
> > > Could you please try this patch? Can it fix the error?
> > >
> > > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> >
> > Oh what a good idea.
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
>
> Heh, we came full circle here, this was Rob's original patch :)

/me pleads the fifth.

(I'm all for a better fix in .24, but for .23.x this is a one-liner...)

> Rob, I'll queue this up for the next cycle, now that you've verified
> that it was not fixed already, thanks for testing.

Thanks for fixing it.

> greg k-h

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
