Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZF3Ste@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZF3Ste (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZF3St0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:49:26 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:44594 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751379AbZF3StZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:49:25 -0400
Date: Tue, 30 Jun 2009 20:41:01 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090630184101.GI23292@game.jcrosoft.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C7@SJEXCHCCR02.corp.ad.broadcom.com>
 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C8@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6786924638583303059
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:30 Fri 26 Jun     , Leo (Hao) Chen wrote:
> Hi,
> 
> The last patch. This big patch includes the minimal set of our CSP (chip support package), which is our OS independent chip supporting code and headers.  All the codes are under arch/arm/mach-bcmring directory.
This patch is unreadable
you need
1) Respect the Linux coding Style
2) to split in small changeset
3) use the kernel API such as clocksource, clock, dmaengine etc...

Best Regards,
J.
