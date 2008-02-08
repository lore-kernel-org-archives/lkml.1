Return-Path: <linux-kernel-owner+w=401wt.eu-S935667AbYBHBiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935667AbYBHBiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761701AbYBHBhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:37:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180AbYBHBhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:37:47 -0500
Date: Thu, 7 Feb 2008 17:35:04 -0800
From: Greg KH <gregkh@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/45] 2.6.24-stable review
Message-ID: <20080208013504.GA3891@suse.de>
References: <20080207204549.GA16389@suse.de> <20080208004430.GE155407@sgi.com> <20080208011230.GA28390@kroah.com> <20080208012457.GI155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208012457.GI155407@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 12:24:57PM +1100, David Chinner wrote:
> On Thu, Feb 07, 2008 at 05:12:30PM -0800, Greg KH wrote:
> > On Fri, Feb 08, 2008 at 11:44:30AM +1100, David Chinner wrote:
> > > Greg,
> > > 
> > > Is there any reason why the XFS patch I sent to the stable list a
> > > couple of days ago is not included in this series?
> > > 
> > > http://oss.sgi.com/archives/xfs/2008-02/msg00027.html
> > > 
> > > We've had multiple reports of it, and multiple confirmations that
> > > the patch in the link above fixes the problem.....
> > 
> > I didn't think it was in Linus's tree yet.  Is it?
> 
> Not yet - it's in the pipeline. I'll see if that can be sped
> up (someone else usually takes care of the pushes to Linus).

Then we did our job right and didn't take it :)

Please resend it after it gets into Linus's tree, not before, I'm really
tired of checking for these things constantly...

thanks,

greg k-h
