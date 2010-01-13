Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335Ab0AMTzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0AMTzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765Ab0AMTzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:55:13 -0500
Received: from kroah.org ([198.145.64.141]:60465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab0AMTzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:55:11 -0500
Date: Wed, 13 Jan 2010 11:52:26 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Julia Lawall <julia@diku.dk>,
       N?meth M?rton <nm127@freemail.hu>, David Vrabel <david.vrabel@csr.com>,
       linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       cocci@diku.dk
Subject: Re: Changelog quality
Message-ID: <20100113195226.GD8438@kroah.com>
References: <20100113174446.GA20754@kroah.com>
 <Pine.LNX.4.44L0.1001131301180.3518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001131301180.3518-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 01:04:52PM -0500, Alan Stern wrote:
> On Wed, 13 Jan 2010, Greg KH wrote:
> 
> > > It would be nice if there was a way to link automatically a git commit
> > > to an archived copy of the email message in which it was originally 
> > > submitted.
> > 
> > Ingo has been doing this on some patches by putting a message-id field
> > in the signed-off-by area showing what lkml message a patch came from.
> > 
> > See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
> > tree as an example of this.
> > 
> > I have no objection if people want to do this for any patches going
> > through my tree as well.
> 
> If it has to be included manually by the patch submitter then it isn't
> automatic.  Not to mention that the submitter would need to know the
> email's message-id before the email message was sent!
> 
> Something like this should belong in a maintainer's script.

Yeah, that would get messy, as usually a patch happens in a different
thread than the original problem occurs, so it would take a lot more
work on my part to try to match things up.  If I notice it, I will try
to in the future.

thanks,

greg k-h
