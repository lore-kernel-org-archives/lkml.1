Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYJOU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYJOU2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYJOU2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:28:04 -0400
Received: from kroah.org ([198.145.64.141]:42714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYJOU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:28:03 -0400
Date: Wed, 15 Oct 2008 12:17:20 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 0/2] x86: check correctness of IRQ0 override
	on systems with ATI/AMD SB450/SB600 chipsets
Message-ID: <20081015191720.GA7966@kroah.com>
References: <20081015104118.GA4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015104118.GA4706@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 12:41:18PM +0200, Andreas Herrmann wrote:
> Hi,
> 
> following patches should go into 2.6.27-stable tree.
> 
> They fix issues with HP Laptops that provide a wrong override for IRQ0
> and which change the thermal trip point as soon as Linux unmasks
> IOAPIC INT2.

Are these patches in the upstream Linus kernel already?

If so, can you please give us the git commit ids?

thanks,

greg k-h
