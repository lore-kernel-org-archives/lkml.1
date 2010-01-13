Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795Ab0AMSE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab0AMSE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576Ab0AMSE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:04:57 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56290 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753769Ab0AMSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:04:53 -0500
Date: Wed, 13 Jan 2010 13:04:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Julia Lawall <julia@diku.dk>,
       N?meth M?rton <nm127@freemail.hu>, David Vrabel <david.vrabel@csr.com>,
       <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       <cocci@diku.dk>
Subject: Re: Changelog quality
In-Reply-To: <20100113174446.GA20754@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1001131301180.3518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Greg KH wrote:

> > It would be nice if there was a way to link automatically a git commit
> > to an archived copy of the email message in which it was originally 
> > submitted.
> 
> Ingo has been doing this on some patches by putting a message-id field
> in the signed-off-by area showing what lkml message a patch came from.
> 
> See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
> tree as an example of this.
> 
> I have no objection if people want to do this for any patches going
> through my tree as well.

If it has to be included manually by the patch submitter then it isn't
automatic.  Not to mention that the submitter would need to know the
email's message-id before the email message was sent!

Something like this should belong in a maintainer's script.

Alan Stern

