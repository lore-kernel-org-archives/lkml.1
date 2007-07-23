Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbXGWXR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbXGWXR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934506AbXGWXRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:17:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934494AbXGWXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:17:23 -0400
Date: Mon, 23 Jul 2007 16:16:41 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 4/9] topology: remove topology_dev_map
Message-ID: <20070723231641.GA26202@suse.de>
References: <20070722153312.083951746@gmail.com> <20070722153355.037575187@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722153355.037575187@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 12:33:16AM +0900, Akinobu Mita wrote:
> By previous cpu hotplug notifier change, we don't need to track
> topology_dev existence for each cpu by topology_dev_map.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

I'm guessing that this is going to have to go in through some other tree
than mine, so feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
