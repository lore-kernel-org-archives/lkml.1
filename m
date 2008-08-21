Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYHUOWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYHUOWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbYHUOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:21:30 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:33503 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYHUOV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:21:27 -0400
Date: Thu, 21 Aug 2008 16:21:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: New subsystems: Ultra-Wideband radio, Wireless USB and WiMedia LLC Protocol
Message-ID: <20080821142157.GB20956@uranus.ravnborg.org>
References: <48AD6AF0.3050504@csr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD6AF0.3050504@csr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:17:36PM +0100, David Vrabel wrote:
> I'm the maintainer of the Ultra-Wideband (UWB) radio, Certified Wireless
> USB (WUSB) and WiMedia LLC Protocol (WLP) subsystems.  These are now in
> a state were I consider them suitable for inclusion into the kernel.
> 
> UWB is a new high speed, short range radio technology (480 Mbit/s at 1
> m, 53.3 Mbit/s at 10 m).  The specifications are freely available and
> are managed by the WiMedia Alliance.   For more information see
> http://www.wimedia.org/.
> 
> Various protocols run on top of the UWB radio: Certified Wireless USB
> (WUSB); WiMedia LLC Protocol (WLP), for IP (etc) networks; and (in the
> future) high speed Bluetooth.
> 
> The code is some 35,000 lines so I won't be posting it to this list but
> you can view the patch set here:

Can you post a serie of patches that just include the core parts - and no drivers?
Let see this first and then we can look at the drivers.

	Sam
