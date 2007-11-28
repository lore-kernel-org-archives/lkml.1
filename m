Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbXK1U2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbXK1U2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbXK1U2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:28:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:50036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXK1U2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:28:00 -0500
Date: Wed, 28 Nov 2007 12:27:08 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Oops in USB / dev code plugging/unplugging multi flash
	reader
Message-ID: <20071128202708.GA3809@suse.de>
References: <474DC95B.7000201@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474DC95B.7000201@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 03:02:35PM -0500, Mark Lord wrote:
>
> While testing a new USB reader/cable today,
> I was plugging/unplugging the USB multi-flash reader (22 in 1),
> and produced this weird oops.
>
> There's a locking problem in there somewhere, Greg.
>
> 2.6.23.8

Can you duplicate this without the closed source ATI graphics driver
loaded?

thanks,

greg k-h
