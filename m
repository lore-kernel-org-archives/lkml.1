Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZAECvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZAECvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZAECvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:51:08 -0500
Received: from 219-87-157-155.static.tfn.net.tw ([219.87.157.155]:51129 "EHLO
	ironport.rdc.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbZAECvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:51:07 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2009 21:51:06 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: Re: [Fwd: [PATCH] it821x: Add ultra_mask quirk for Vortex86SX]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 5 Jan 2009 10:40:37 +0800
Message-ID: <07905E0D268758488D76D7D747F21BB6027C02FE@rdc8.rdc>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [Fwd: [PATCH] it821x: Add ultra_mask quirk for Vortex86SX]
thread-index: Aclu3v1y5zkq8ZnFSBC85THkTpPBZw==
From: =?big5?B?Sm9lIENob3UgKKlQqHy9bik=?= <Joe.Chou@rdc.com.tw>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15:44 Tue 09 Dec 2008, Daniel Gimpelevich wrote:
> On Tue, 2008-12-09 at 21:12 +0100, Florian Fainelli wrote:
> > Which PHY is connected to the R6040 MAC ? It could be related to 
> > some wrong settings of the PHY in the driver initialization. 
> > Currently we are assuming that etiher we are attached to an ICplus 
> > IP175C switch or another PHY.
> 
> Additionally, the 2.6 mainline version had a stupid race condition in 
> its initialization for a long time, and without looking at current 
> mainline, I am assuming it's still there. The r6040.c in the current 
> SVN trunk of OpenWRT is an improvement over that:
> https://svn.openwrt.org/openwrt/trunk/target/linux/rdc/files/drivers/n
> et/r6040.c
