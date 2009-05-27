Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbZE0T5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbZE0T5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbZE0T5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:57:09 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50466 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954AbZE0T5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:57:08 -0400
Message-ID: <4A1D9A66.5020002@freescale.com>
Date: Wed, 27 May 2009 14:54:14 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090504 SeaMonkey/2.0a3
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <4A1D9A1E.80603@freescale.com>
In-Reply-To: <4A1D9A1E.80603@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> The patches that were proposed (and NACKed) in u-boot did exactly this 
> -- except supposedly they would only set the MAC address if the 
> interface were actually used prior to booting the kernel.

How does a Linux driver normally get a MAC address if it's not passed via the device tree and it isn't already programmed in the hardware?  Is there some file in /etc that stores these things?

-- 
Timur Tabi
Linux kernel developer at Freescale
