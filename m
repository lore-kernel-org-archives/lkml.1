Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYA1E0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYA1E0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYA1E0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:26:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37779 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYA1E03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:26:29 -0500
Date: Sun, 27 Jan 2008 20:24:49 -0800
From: Greg KH <greg@kroah.com>
To: Romit Dasgupta <romlinux@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, stern@rowland.harvard.edu,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Moving spinlock to struct usb_hcd
Message-ID: <20080128042449.GA6374@kroah.com>
References: <1201329041.5807.20.camel@maxwell> <200801260021.50786.david-b@pacbell.net> <9f29ca150801260736j205b67d2jf9b57d3ac05176a2@mail.gmail.com> <9f29ca150801272020t2ced46b6ka8e7890dfbe1e1a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f29ca150801272020t2ced46b6ka8e7890dfbe1e1a8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:50:36AM +0530, Romit Dasgupta wrote:
> Hi,
>                  Should I go ahead and submit the patch with the usual
> "signed-off" thingie? Or is it totally useless patch that is going to
> be ignored?

Let's see some proof that it actually helps, and then we can evaluate if
it is needed or not :)

thanks,

greg k-h
