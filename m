Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbYBHBZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbYBHBZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbYBHBZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:25:49 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33546 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760530AbYBHBZs (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:25:48 -0500
Date: Fri, 8 Feb 2008 12:24:57 +1100
From: David Chinner <dgc@sgi.com>
To: Greg KH <greg@kroah.com>
Cc: David Chinner <dgc@sgi.com>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
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
Message-ID: <20080208012457.GI155407@sgi.com>
References: <20080207204549.GA16389@suse.de> <20080208004430.GE155407@sgi.com> <20080208011230.GA28390@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208011230.GA28390@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 05:12:30PM -0800, Greg KH wrote:
> On Fri, Feb 08, 2008 at 11:44:30AM +1100, David Chinner wrote:
> > Greg,
> > 
> > Is there any reason why the XFS patch I sent to the stable list a
> > couple of days ago is not included in this series?
> > 
> > http://oss.sgi.com/archives/xfs/2008-02/msg00027.html
> > 
> > We've had multiple reports of it, and multiple confirmations that
> > the patch in the link above fixes the problem.....
> 
> I didn't think it was in Linus's tree yet.  Is it?

Not yet - it's in the pipeline. I'll see if that can be sped
up (someone else usually takes care of the pushes to Linus).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
