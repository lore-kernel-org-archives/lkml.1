Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164Ab0AVSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0AVSeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144Ab0AVSeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:34:18 -0500
Received: from kroah.org ([198.145.64.141]:53711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab0AVSeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:34:18 -0500
Date: Fri, 22 Jan 2010 10:33:22 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: Introduction to rar_register patch set of 5 patches
Message-ID: <20100122183322.GA9512@kroah.com>
References: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
 <20100122102308.bb17fd1a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122102308.bb17fd1a.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 10:23:08AM -0800, Randy Dunlap wrote:
> On Fri, 22 Jan 2010 09:53:30 -0800 Mark Allyn wrote:
> 
> > The following five patches are for the Restricted Access Region
> > Register (rar_register) driver.
> > 
> > This driver is for the Intel MID platform.
> 
> Hi Mark,
> 
> Please read and try to follow Documentation/SubmittingPatches.
> 
> E.g.:
> 
> "The canonical patch subject line is:
> 
>     Subject: [PATCH 001/123] subsystem: summary phrase"
> 
> so your patch 1 should be more like:
> 
> [PATCH 1/5] rar_register: rename rar_driver to rar_register
> 
> and then that one patch's description should be at the top of that
> email's body, not in the patch introduction/cover email.
> 
> As it stands, these 5 patch descriptions need to be moved
> to each patch's patch description...

I agree, I can not apply these as-is.

Mark, please redo the patches.

Hint, we do have tools that make this much easier, like quilt and git,
you might take the time to learn to use them so that future patch
submissions are not bungled as badly as these have been.

thanks,

greg k-h
