Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZHTUnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZHTUnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZHTUnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:43:40 -0400
Received: from kroah.org ([198.145.64.141]:58573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbZHTUni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:43:38 -0400
Date: Thu, 20 Aug 2009 13:42:11 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: fix typos
Message-ID: <20090820204211.GA16198@kroah.com>
References: <20090820192915.GB15574@kroah.com>
 <Pine.LNX.4.44L0.0908201533540.2670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908201533540.2670-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:34:40PM -0400, Alan Stern wrote:
> On Thu, 20 Aug 2009, Greg KH wrote:
> 
> > On Thu, Aug 20, 2009 at 03:23:47PM -0400, Alan Stern wrote:
> > > This patch (as1282) fixes some obvious typos in the TTY core.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > 
> > Ick, this looks like it needs to go in for .31, right?
> 
> No, these are typos in the new code queued for .32.  2.6.31 looks all 
> right.

Ok, thanks for letting me know.

greg k-h
