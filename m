Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0CBX1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:27:43 -0500
Received: from kroah.org ([198.145.64.141]:37522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0CBX1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:27:42 -0500
Date: Tue, 2 Mar 2010 15:27:38 -0800
From: Greg KH <greg@kroah.com>
To: Chris Largret <largret@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Lin <paul_lin@ralinktech.com>
Subject: Re: 2.6.33 staging rt2870 += Belkin F5D8055 Wireless-N USB Dongle
Message-ID: <20100302232738.GA314@kroah.com>
References: <20100302162228.3eeda8f3@shogun.epicvoyage.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302162228.3eeda8f3@shogun.epicvoyage.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:22:28PM -0600, Chris Largret wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hey,
> 
> I bought a Belkin F5D8055 Wireless-N USB Dongle recently. The driver
> CD holds files with names like "rt2870.inf."
> 
> The current (kernel 2.6.33) Ralink staging module works with it after a
> slight tweak to add the Belkin USB device information. The attached
> patch is designed to do that.
> 
> It modifies the rt2860 tree but is targeted at the rt2870 driver.
> 
> Feel free to e-mail me if you have any questions.

Next time, please cc: me with any staging patches.

Can you resend this with a "Signed-off-by:" line so that I can apply it?
The kernel file, Documentation/SubmittingPatches describes what this
entails.

thanks,

greg k-h
