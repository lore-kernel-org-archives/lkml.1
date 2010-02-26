Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528Ab0BZIE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:04:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:04:27 -0500
Date: Fri, 26 Feb 2010 09:04:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Martin Fuzzey <mfuzzey@gmail.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the usb tree with the i.MX tree
Message-ID: <20100226080422.GB24846@pengutronix.de>
References: <20100226181003.a08c83cf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100226181003.a08c83cf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 06:10:03PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-mx2/devices.h between commit
> 68c94b40b31926f627573a7f656b903f6644744e ("arm/mx2: use cpp magic to
> create spi_imx devices") from the i.MX tree and commit
> 3f1c5d0f4c64f5e9e4ac329a935b3da67593691f ("USB: MXC: add platform
> resources for i.MX21 USB host controller") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
Looks OK, thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
