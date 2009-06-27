Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZF0Fkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZF0Fkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZF0Fkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:40:33 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:48602 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752012AbZF0Fkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:40:33 -0400
Date: Sat, 27 Jun 2009 07:33:17 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090627053317.GG8587@game.jcrosoft.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C3@SJEXCHCCR02.corp.ad.broadcom.com>
 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12739838921815075731
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:29 Fri 26 Jun     , Leo (Hao) Chen wrote:
> Hi,
> 
> This is the third patch.  This big patch contains the core arch code in arch/arm/mach-bcmring directory.
> Header files in arch/arm/mach-bcmring/include/mach are included as well.
You need to check your patches with checkpatch.pl as your patches do not respect
the linux conding style in a lot's of space

> 
> >From 8c38c714343f1cc203c55db8fd28505b1ec4f914 Mon Sep 17 00:00:00 2001
> From: Leo Chen <leochen@broadcom.com>
> Date: Fri, 26 Jun 2009 15:46:41 -0700
> Subject: [PATCH 3/6] add bcmring arch core code and header files
> 
a few more details will be nice
please split a few too it will help for review

Best Regards,
J.
