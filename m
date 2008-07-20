Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYGTWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYGTWlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYGTWlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:41:09 -0400
Received: from eazy.amigager.de ([213.239.192.238]:33553 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYGTWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:41:08 -0400
Date: Mon, 21 Jul 2008 00:42:04 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org
Subject: Re: no direct rendering with 2.6.26 due to AGP after DRM
Message-ID: <20080720224204.GA16111@dose.home.local>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org
References: <20080720220140.GA14818@dose.home.local> <alpine.DEB.0.82.0807202337270.22311@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0807202337270.22311@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 23:37:51 +0100, Dave Airlie wrote:
> 
> > 
> > [drm] Initialized drm 1.1.0 20060810
> > ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> > PCI: Setting latency timer of device 0000:00:02.0 to 64
> > [drm:drm_fill_in_dev] *ERROR* Cannot initialize the agpgart module.
> > DRM: Fill_in_dev failed.
> > ...
> > agpgart: Detected an Intel 965GM Chipset.
> > agpgart: Detected 7676K stolen memory.
> > agpgart: AGP aperture is 256M @ 0xe0000000
> > 
> 
> For now don't built it all into the kernel :)
> 
> I'll see what I can dig up on init ordering.

My bad. I didn't use 2.6.26, but some git version after 2.6.26. Another
computer with a real 2.6.26 was fine, so scratch all of the above.

Regards,
Tino
