Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYBKHtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYBKHtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYBKHsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:48:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBKHsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:48:54 -0500
Date: Sun, 10 Feb 2008 23:53:14 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, ndenev@gmail.com,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, akpm@linux-foundation.org, oliver.pntr@gmail.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] [PATCH] vmsplice exploit fix (was: splice: fix user
	pointer access in get_iovec_page_array)
Message-ID: <20080211075314.GA7717@kroah.com>
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI> <200802102329.50843.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802102329.50843.phillips@phunq.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 11:29:50PM -0800, Daniel Phillips wrote:
> Kudos to all involved in the rapid response.  But.
> 
> Information on patching this vulnerability is not available front and 
> center in many of the places you would expect: kernel.org front page, 
> debian.org front page, covered on planet.debian.org but without a 
> pointer to the patch, and so on.  So this post provides a subject line 
> for Google to find, and for good measure mentions the word 
> vulnerability.

All currently active Linux kernel versions are now released with a fix
for this problem.  We have released them through our normal channels,
with the needed information as to what the problem is, a pointer to the
CVE number, and the patch itself.

I don't think there's much more we need to do here, do you?

thanks,

greg k-h
