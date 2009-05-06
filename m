Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbZEFPAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbZEFPAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZEFO7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:59:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:44564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760238AbZEFO7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:59:47 -0400
Date: Wed, 6 May 2009 07:56:26 -0700
From: Greg KH <gregkh@suse.de>
To: prashant@arasan.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: New MIPI driver integration to linux kernel
Message-ID: <20090506145626.GC3478@suse.de>
References: <1241604509.577511031@192.168.1.202>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241604509.577511031@192.168.1.202>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:38:29PM +0530, prashant@arasan.com wrote:
> 
> Hello,
> 
> We are exploring options to integrate a new driver based on MIPI
> alliances protocols such as SLIMbus, HSI etc into the linux kernel. We
> have done all validation / compliance based on the guidelines provided
> in the kernel source (Documentation/Submittingdrivers).
> 
> I want greater details on how to submit a new driver for inclusion in
> the linux kernel. I have following queries:
> 
> 1. Who can I contact (xxx) to help me integrate the new driver to the
> kernel?

I'd be glad to help out.

> 2. Do I need to send the source code to xxx, who integrates it to the
> kernel or do I need to send a patch for the kernel to xxx?

If you have patches, that's the best way.

> 3. Since we need to add a new folder in the drivers/<subsystem> - Will
> it require some permission from the linux community?

Not really "permission", just an agreement that you really do need a new
directory is all that is needed.

Just post your patches here and we can review it and take it from there.

thanks,

greg k-h
