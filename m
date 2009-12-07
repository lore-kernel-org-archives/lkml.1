Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZLGALE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZLGALE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZLGALC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:11:02 -0500
Received: from kroah.org ([198.145.64.141]:34130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbZLGALB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:11:01 -0500
Date: Sun, 6 Dec 2009 16:10:58 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [000/119] 2.6.31.7-stable review
Message-ID: <20091207001058.GA24769@kroah.com>
References: <20091207000938.GA24743@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207000938.GA24743@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 04:09:38PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.31.7 release.
> There are @num@ patches in this series, all will be posted as a response

There are 119 patches, doh...

> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Oh, also, just for those keeping score, this _only_ includes patches
that went into Linus's tree for the 2.6.32 release.  There have already
been a number of -stable patches that went in after 2.6.32 was released,
as part of the 2.6.33 release cycle.  They will be handled in future
releases of .31, but not this one, it's big enough.

thanks,

greg k-h
