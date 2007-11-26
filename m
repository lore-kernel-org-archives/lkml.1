Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXKZWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXKZWAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbXKZWAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:00:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:57782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbXKZWAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:00:39 -0500
Date: Mon, 26 Nov 2007 14:00:20 -0800
From: Greg KH <gregkh@suse.de>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.14
Message-ID: <20071126220020.GA10703@suse.de>
References: <20071121175644.GA1329@kroah.com> <20071121175701.GB1329@kroah.com> <1196000495.18901.8.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196000495.18901.8.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 06:21:35AM -0800, Sven-Thorsten Dietrich wrote:
> Hi Greg,
> 
> I think this hunk in the 2.6.22.14 stable patch may be a mis-patch --
> compared to Linus's current git -- the new code should be inserted below
> the while loop that follows.
> 
> Also see commit 9f96cb1e8bca179a92afa40dfc3c49990f1cfc71

Hm, I'm confused.  Why is this a mis-patch?

Care to send me a fix against 2.6.22.14 that solves this issue?

thanks,

greg k-h
