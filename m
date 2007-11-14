Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbXKNA0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbXKNA0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbXKNA0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:26:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54538 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993AbXKNA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:26:38 -0500
Date: Tue, 13 Nov 2007 16:22:14 -0800
From: Greg KH <greg@kroah.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       Dan Williams <dan.j.williams@intel.com>, M@suse.de,
       linux-kernel@vger.kernel.org, Stable <stable@kernel.org>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Message-ID: <20071114002214.GA31928@kroah.com>
References: <20071022171426.31103.patches@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022171426.31103.patches@notabene>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:15:27PM +1000, NeilBrown wrote:
> 
> It appears that a couple of bugs slipped in to md for 2.6.23.
> These two patches fix them and are appropriate for 2.6.23.y as well
> as 2.6.24-rcX
> 
> Thanks,
> NeilBrown
> 
>  [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
>  [PATCH 002 of 2] md: raid5: fix clearing of biofill operations

I don't see these patches in 2.6.24-rcX, are they there under some other
subject?

thanks,

greg k-h
