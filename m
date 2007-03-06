Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXCFDIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXCFDIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 22:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933885AbXCFDIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 22:08:10 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:57988 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbXCFDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 22:08:08 -0500
Date: Tue, 6 Mar 2007 03:07:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Matt Mackall <mpm@selenic.com>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Message-ID: <20070306030735.GA6769@srcf.ucam.org>
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305195530.GM23311@waste.org> <20070305223900.GA7676@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305223900.GA7676@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:39:00PM -0800, Greg KH wrote:

> Ok, I only named HAL as that is what people have told me the problem is.
> I have been running this change on my boxs, without
> CONFIG_SYSFS_DEPRECATED since last July or so.
> 
> But I don't use NetworkManager here for the most part, but I have tried
> this in the OpenSuse10.3 alpha releases and it seems to work just fine
> with whatever version of NetworkManager it uses.

At a guess, you're carrying either a git snapshot or have backports from 
git. Several distributions do this, but until there's actually been a 
released version that works, it's a bit early to set a timescale.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
