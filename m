Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZF3BJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZF3BJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZF3BJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:09:12 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3252 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF3BJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:09:12 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Mon, 29 Jun 2009 18:09:02 -0700
Subject: RE: [PATCH v1 3/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 3/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn26dQsQ/DevaaLS9ukpiv3e//jUwCNVhfQ
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1A06@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C3@SJEXCHCCR02.corp.ad.broadcom.com>
 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com>
 <20090627053317.GG8587@game.jcrosoft.org>
In-Reply-To: <20090627053317.GG8587@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6657BA3A4CG12574038-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 

> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com] 
> Sent: Friday, June 26, 2009 10:33 PM
> To: Leo (Hao) Chen
> Cc: linux-arm-kernel@lists.arm.linux.org.uk; Linux Kernel
> Subject: Re: [PATCH v1 3/6][ARM] new ARM SoC support: BCMRing
> 
> On 16:29 Fri 26 Jun     , Leo (Hao) Chen wrote:
> > Hi,
> > 
> > This is the third patch.  This big patch contains the core 
> arch code in arch/arm/mach-bcmring directory.
> > Header files in arch/arm/mach-bcmring/include/mach are 
> included as well.
> You need to check your patches with checkpatch.pl as your 
> patches do not respect
> the linux conding style in a lot's of space
> 
I'll fix the errors found by the checkpatch.pl script.  Is it okay to pass the checkpatch.pl with some warnings?

> > 
> > >From 8c38c714343f1cc203c55db8fd28505b1ec4f914 Mon Sep 17 
> 00:00:00 2001
> > From: Leo Chen <leochen@broadcom.com>
> > Date: Fri, 26 Jun 2009 15:46:41 -0700
> > Subject: [PATCH 3/6] add bcmring arch core code and header files
> > 
> a few more details will be nice
> please split a few too it will help for review
> 
> Best Regards,
> J.
> 
> 


 
Leo Hao Chen
Software Engineer
Broadcom Canada Inc.

