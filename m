Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZF3XUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZF3XUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760741AbZF3XTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:19:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48231 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760751AbZF3XTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:19:38 -0400
Date: Wed, 1 Jul 2009 00:20:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Leo (Hao) Chen" <leochen@broadcom.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090701002054.44e6f688@lxorguk.ukuu.org.uk>
In-Reply-To: <20090630184101.GI23292@game.jcrosoft.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C7@SJEXCHCCR02.corp.ad.broadcom.com>
	<8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
	<20090630184101.GI23292@game.jcrosoft.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 20:41:01 +0200
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> On 16:30 Fri 26 Jun     , Leo (Hao) Chen wrote:
> > Hi,
> > 
> > The last patch. This big patch includes the minimal set of our CSP (chip support package), which is our OS independent chip supporting code and headers.  All the codes are under arch/arm/mach-bcmring directory.
> This patch is unreadable
> you need
> 1) Respect the Linux coding Style

For an OS independant set of chip support defines that usually makes no
sense

> 2) to split in small changeset

For a new submission that generally doesn't make much sense either - not
for all the new files stuff.

