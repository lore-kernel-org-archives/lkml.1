Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbZE1Dgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbZE1Dgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZE1Dg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:36:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:14833 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZE1Dg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <20090528025718.GC1464@yookeroo.seuss>
References: <1243408083.13460.14.camel@debian-nb> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> 
	<20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> 
	<20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> 
	<20090528000707.GR6805@pengutronix.de> <20090528025718.GC1464@yookeroo.seuss>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 21:36:08 -0600
Message-ID: <fa686aa40905272036ueb35e6do86160788ab7c7d8a@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Robert Schwebel <r.schwebel@pengutronix.de>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 8:57 PM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> Grant mentions the Xilinx devices as an example - they're interesting
> because of the fancy stuff they're doing, autogenerating the devtree
> from the FPGA configuration.  But to me the real indicator of the
> device tree's value is the handful of platforms for which support has
> been added with *only* a new dts - a single, fairly simple text file.

Yes, exactly!  Even with the .dtb blob linked into the kernel image
this has been a huge win in simplicity.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
