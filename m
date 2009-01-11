Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZAKHcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZAKHcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZAKHcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:32:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:37252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZAKHcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:32:41 -0500
Date: Sat, 10 Jan 2009 23:31:27 -0800
From: Greg KH <gregkh@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
Message-ID: <20090111073127.GA8283@suse.de>
References: <adaljtjog90.fsf@cisco.com> <adad4evoeu9.fsf@cisco.com> <ac3eb2510901092230i5f1a37c6s8e7ef20cfaf67dc6@mail.gmail.com> <adapriumj1c.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adapriumj1c.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 10:52:15PM -0800, Roland Dreier wrote:
>  > Great! Thanks a lot for fixing this,
> 
> I assume you will make sure this gets upstream (since the problem causes
> some boxes with root on cciss to panic on boot, and possibly breaks
> other stuff)?

Yes, I'll queue it up on Monday.

thanks,

greg k-h
