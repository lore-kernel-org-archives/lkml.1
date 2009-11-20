Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZKTTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZKTTRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZKTTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:17:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:49679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZKTTRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:17:41 -0500
Date: Fri, 20 Nov 2009 11:17:39 -0800
From: Greg KH <gregkh@suse.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH] Staging: IIO: Add tsl2560-2 support to tsl2563 driver
 + drop tsl2561, driver.
Message-ID: <20091120191739.GA16233@suse.de>
References: <4B06EA3B.10500@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B06EA3B.10500@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:12:59PM +0000, Jonathan Cameron wrote:
> These parts (tsl2560-tsl2563) are identical in interface.
> The tsl2563 driver is more advanced so makes sense to drop
> the tsl2561 driver.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
> Greg, I've done the changes and driver removal as a single patch.
> Can separate into two if you would prefer?

Yes, please split this into 2 patches, it's easier to review that way.

thanks,

greg k-h
