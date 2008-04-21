Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYDUGWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYDUGWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYDUGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:21:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:49427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDUGVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:21:55 -0400
Date: Sun, 20 Apr 2008 23:28:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, mingo@redhat.com,
       jbarnes@virtuousgeek.org
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: PCI MAINTAINER change
Message-ID: <20080421062806.GA4919@suse.de>
References: <20080421062139.GA4901@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421062139.GA4901@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 11:21:39PM -0700, Greg KH wrote:
> Here are a some PCI and PCI hotplug patches against your 2.6.25 git tree.
> 
> They contain:
> 	- documentation movement into a new directory
> 	- pci section warning fixes
> 	- more generic PCI code for some arches
> 	- removal of the duplicated list of all PCI devices in the system
> 	- second go-around for the PCI ASPM code
> 	- various bugs and other minor stuff
> 	- change the PCI maintainer

I just wanted to highlight this last entry.  I'm passing the PCI
subsystem maintainership on to Jesse Barnes <jbarnes@virtuousgeek.org>

I'd like to thank him for volunteering for the job, something for which
I know he is more than capable.

So those of you who have automated scripts to hit me with PCI
issues/bugs/complaints, might want to adjust them at this point in time.

Now what to do with all of this extra free time I'm going to have...

greg k-h
