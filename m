Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbZE1MwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbZE1MwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZE1MwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:52:05 -0400
Received: from emita2.mittwald.de ([85.199.173.189]:49513 "EHLO
	emita2.mittwald.de" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754764AbZE1MwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:52:04 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 08:52:04 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Thu, 28 May 2009 14:43:21 +0200
User-Agent: KMail/1.9.7
Cc: Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
In-Reply-To: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281443.21747.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lack of device-tree support on ARM has been a real hindrance to
> getting the ARM-based Linux support on par with PowerPC.

And I always thought that this is because Freescale does some BSP 
in the background, then release a BSP with some kernel and 
doesn't even try getting something included in "main" Linus, 
a.k.a. into Linus' tree.

Hey, but that's better then Marvell, where you need to sign an 
NDA to even access the documentation. With Freescale's doc (and 
help of the community!) I was able to get some Freescale i.MX21 
related drivers into Linus' tree.
