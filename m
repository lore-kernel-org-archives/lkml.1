Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYBCXYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYBCXYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYBCXXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:23:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYBCXXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:23:51 -0500
Date: Sun, 3 Feb 2008 15:15:30 -0800
From: Greg KH <greg@kroah.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080203231530.GB15692@kroah.com>
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A5F418.6030104@weinigel.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 06:04:24PM +0100, Christer Weinigel wrote:
> Pekka Enberg wrote:
>> Why are we discussing this again? The Linux kernel is distributed
>> under the GPLv2 and even though there are some legal gray areas
>> regarding derived work (think nvidia and ati binary blobs here), the
>> license is not friendly towards proprietary drivers at all.
>
> Why?  Because it is a gray area.

No, it really is not a gray area at all, especially when you are writing
a new driver for Linux.  Go talk to a lawyer if you want the details.

thanks,

greg k-h
