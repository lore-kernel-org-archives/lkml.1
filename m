Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247Ab0AMRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0AMRof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192Ab0AMRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:44:32 -0500
Received: from kroah.org ([198.145.64.141]:46813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0AMRoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:44:30 -0500
Date: Wed, 13 Jan 2010 09:44:46 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Julia Lawall <julia@diku.dk>,
       N?meth M?rton <nm127@freemail.hu>, David Vrabel <david.vrabel@csr.com>,
       linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       cocci@diku.dk
Subject: Re: Changelog quality
Message-ID: <20100113174446.GA20754@kroah.com>
References: <4B4DFD87.3000904@s5r6.in-berlin.de> <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:29:07PM -0500, Alan Stern wrote:
> On Wed, 13 Jan 2010, Stefan Richter wrote:
> 
> > If it was by mistake, inclusion of the find-and-replace script into the
> > patch posting *after the --- delimiter* might have increased the chance
> > that a patch reviewer becomes aware of a possible error source
> > (inadequate match patterns...).  So that could be useful during review
> > before commit, but not so much if the change is revisited some time
> > after commit.
> 
> Somewhat tangentially, it's worth mentioning that the comments
> appearing after the "---" delimiter exist only in the original patch
> submissions, not in the final commits.  Hence they are not available to
> anyone reviewing the changes after acceptance.
> 
> It would be nice if there was a way to link automatically a git commit
> to an archived copy of the email message in which it was originally 
> submitted.

Ingo has been doing this on some patches by putting a message-id field
in the signed-off-by area showing what lkml message a patch came from.

See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
tree as an example of this.

I have no objection if people want to do this for any patches going
through my tree as well.

thanks,

greg k-h
