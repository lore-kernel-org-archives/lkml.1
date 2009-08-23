Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbZHWQ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbZHWQ7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933969AbZHWQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:59:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:51571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933963AbZHWQ7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:59:47 -0400
Date: Sun, 23 Aug 2009 09:49:42 -0700
From: Greg KH <gregkh@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: devel@driverdev.osuosl.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] Staging: rt{286,287,307}0: merge rt3070 with
 rt2870
Message-ID: <20090823164942.GA2513@suse.de>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 03:28:46PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> The final part of rt2870 and rt3070 merge.
> 
> It adds RT3070 chipset support to rt2870 driver and removes no longer needed
> rt3070 driver (yes, it means one Ralink driver less in the staging tree!).
> 
> [ in the process many bugs in all Ralink drivers were fixed, RT2870 chipset
>   support was converted to use the new firmware and ~1.5 KLOC were removed ]

Wonderful work, thanks so much for doing this.  I'll merge these into my
tree when I get home tomorrow.

thanks again,

greg k-h
