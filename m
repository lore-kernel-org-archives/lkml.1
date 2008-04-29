Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYD2S2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYD2S2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYD2S1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:27:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbYD2S1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:27:54 -0400
Date: Tue, 29 Apr 2008 11:27:17 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: PCI tree info
Message-ID: <20080429182717.GA17500@kroah.com>
References: <200804291100.08622.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291100.08622.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:00:08AM -0700, Jesse Barnes wrote:
> The PCI tree now lives in git:  
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.  There are a 
> few branches:
>   for-linus - stuff headed to Linus in the next pull request
>   linux-next - patches targetted at the following release
>   master - unmodified Linus upstream branch
> 
> I'll try to avoid re-basing, but since the main downstream tree is the PCI 
> hotplug tree, and Kristen uses quilt, that probably won't be much of an 
> issue.

You should send in a patch to MAINTAINERS to point to this new tree
there.

thanks,

greg k-h
