Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXDYAxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXDYAxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXDYAxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:53:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57474 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbXDYAxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:53:21 -0400
Date: Tue, 24 Apr 2007 17:51:11 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425005111.GA22673@kroah.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com> <20070424093253.GA1075@erig.dyndns.org> <20070425001428.GA1366@kroah.com> <20070425002958.GR3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425002958.GR3468@stusta.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 02:29:58AM +0200, Adrian Bunk wrote:
> On Tue, Apr 24, 2007 at 05:14:28PM -0700, Greg KH wrote:
> > On Tue, Apr 24, 2007 at 11:32:53AM +0200, Wolfgang Erig wrote:
> > > On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
> > > > On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
> > > > > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > > > > 
> > > > > If you find your name in the Cc header, you are either submitter of one
> > > > > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > > > > of you caused a breakage or I'm considering you in any other way
> > > > > possibly involved with one or more of these issues.
> > > > > 
> > > > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > > > 
> > > > > 
> > > > > Subject    : gammu no longer works
> > > > > References : http://lkml.org/lkml/2007/4/20/84
> > > > > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > > > > Status     : unknown
> > > > 
> > > > I've asked for more information about this, and so far am not sure it's
> > > > a real problem.
> > > 
> > > It is a real problem for me.
> > > I tried this on 2 different boxes with the same behaviour.
> > > No sync between my Nokia mobile and Linux with the latest kernel :(
> > 
> > Sorry, I didn't see your response, have followed up on lkml now.
> 
> It turned out this was actually a bug in Gammu that will be fixed in 
> the next release of Gammu.

Ah, ok, thanks for letting me know.

But how was the kernel version change triggering it?

greg k-h
