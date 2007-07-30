Return-Path: <linux-kernel-owner+w=401wt.eu-S938421AbXG3GCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938421AbXG3GCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXG3GCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:02:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40011 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbXG3GCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:02:24 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 02:02:24 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Testing of CPRM on SD Card
Date: Mon, 30 Jul 2007 11:20:58 +0530
Message-ID: <0A50DBE80DD6674E94F7269DC964A7B6440EDA@dbde01.ent.ti.com>
In-Reply-To: <e1d5030b0707280108v236cc522m454c58e1044f1996@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Testing of CPRM on SD Card
Thread-Index: AcfQ7tmsF38IgwZRSie8/a/besRQdQBfZZDA
From: "Sriram, Kannan" <ksriram@ti.com>
To: "Midhun A" <midhunagni@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>,
       <linux-mtd@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Midhun,

 There is no open-source implementation of CPRM (SD-Audio/ SD-Bind
standards). So first of all, you need to license keys from 4C (device
keys, media keys etc) and do your own implementation.

 The keys that you can download from 4C site are for test purposes only,
and you can't use them to test on a real COTS SD-card. If you really
want to try those dummy keys on an SD-card, I suggest you purchase a few
"development/ test only" SD-cards from popular SD-Card manufacturers
that have been specifically encrypted using those 4C dummy keys.

Regards,
Sriram.

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.arm.linux.org.uk
[mailto:linux-arm-
> kernel-bounces@lists.arm.linux.org.uk] On Behalf Of Midhun A
> Sent: Saturday, July 28, 2007 5:08 PM
> To: linux-kernel@vger.kernel.org;
linux-arm-kernel@lists.arm.linux.org.uk;
> linux-mtd@lists.infradead.org
> Subject: Testing of CPRM on SD Card
> 
> Hi All,
> 
>     Our product development requires that we use the CPRM security
> feature of SD card for protecting our material. I have been searching
> the web for a SD host controller / Software which is CPRM capable, so
> that we can write/read an encrypted SD card with the testing keys
> provided by the 4C Entity) and test our prototype. But I could find
> none. There are IP cores but no manufactured chips.
> 
>    Has anybody of you done similar stuff ? How do I go about testing
> the CPRM feature of the SD card on our prototype ?
> 
> Thanks,
> Midhun.
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-
> kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
