Return-Path: <linux-kernel-owner+w=401wt.eu-S1161124AbXBAFru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161124AbXBAFru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161149AbXBAFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:47:50 -0500
Received: from mail.suse.de ([195.135.220.2]:42981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161124AbXBAFrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:47:49 -0500
Date: Wed, 31 Jan 2007 21:46:44 -0800
From: Greg KH <greg@kroah.com>
To: Sergei Organov <osv@javad.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070201054644.GD5979@kroah.com>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <87fy9r2ixc.fsf@javad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fy9r2ixc.fsf@javad.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 08:41:03PM +0300, Sergei Organov wrote:
> Greg KH <greg@kroah.com> writes:
> [...]
> >> And there are plenty of documented devices that no one cares enough
> >> about to submit a driver for.
> >
> > Any specific examples?  I have a long list of people who wish to write
> > new drivers but just don't know which hardware is not yet supported.
> 
> Maybe not entirely a new driver, as there already exist out-of-kernel
> vendor GPL driver, but if somebody is willing to resolve the issue
> described here:
> 
> <http://article.gmane.org/gmane.linux.serial/1221>
> 
> please contact me, and I'll be willing to help in testing as I have the
> hardware.

Do you have a pointer to the driver source anywhere?

I suggest just posting it as a patch to the tree as documented in
Documentation/SubmittingPatches and seeing how that goes.

thanks,

greg k-h
