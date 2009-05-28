Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbZE1NMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbZE1NMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZE1NMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:12:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46931 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZE1NMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:12:08 -0400
Date: Thu, 28 May 2009 14:12:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528131206.GC19523@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <200905281443.21747.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905281443.21747.hs4233@mail.mn-solutions.de>
X-Cookie: Vitamin C deficiency is apauling.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 02:43:21PM +0200, Holger Schurig wrote:

> Hey, but that's better then Marvell, where you need to sign an 
> NDA to even access the documentation. With Freescale's doc (and 
> help of the community!) I was able to get some Freescale i.MX21 
> related drivers into Linus' tree.

Marvell have improved greatly here compared to the situation in the past
- they are working actively on pushing things into mainline and they've
published several of their chip manuals (all the PXA2xx and PXA3xx stuff
is there, for example).
