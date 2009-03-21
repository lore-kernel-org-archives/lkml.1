Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZCUBrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZCUBrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 21:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCUBrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 21:47:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZCUBrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 21:47:14 -0400
Date: Fri, 20 Mar 2009 17:43:28 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>
Subject: Re: [patch 38/43] drm/i915: set vblank enabled flag correctly
	across IRQ install/uninstall
Message-ID: <20090321004328.GA4396@suse.de>
References: <20090320222810.386844059@mini.kroah.org> <20090320222928.879548230@mini.kroah.org> <1237594162.4892.24.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237594162.4892.24.camel@gaiman.anholt.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 05:09:22PM -0700, Eric Anholt wrote:
> On Fri, 2009-03-20 at 15:28 -0700, Greg KH wrote:
> > plain text document attachment
> > (drm-i915-set-vblank-enabled-flag-correctly-across-irq-install-uninstall.patch)
> > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> 
> I think we're good to go on the DRM series.
> 
> <anholt> jbarnes: any concerns about the vblank patches that just got
> queued to 2.6.28?
> <jbarnes> no, though there's still one regression open against aiglx vt
> switch
> <anholt> ok, but it's a regression before those queued patches?
> <jbarnes> yeah I think so

Great, thanks for letting me know.

greg k-h
