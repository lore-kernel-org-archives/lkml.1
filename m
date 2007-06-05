Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbXFEHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbXFEHlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbXFEHkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:40:52 -0400
Received: from mailgw4.ericsson.se ([193.180.251.62]:52345 "EHLO
	mailgw4.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXFEHkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:40:51 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 03:40:51 EDT
X-AuditID: c1b4fb3e-b1a1dbb0000061ca-6a-46650e4febd8 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 09:18:38 +0200
Message-ID: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se>
In-Reply-To: <200706050710.41754.arvidjaar@mail.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Thread-Index: AcenHx1vCK8PHGQoSCaECdu1ubDu0gAIn0cA
References: <200706031200.07514.arvidjaar@mail.ru> <200706040634.01622.arvidjaar@mail.ru> <20070604204418.GA4214@sortiz.org> <200706050710.41754.arvidjaar@mail.ru>
From: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Samuel Ortiz" <samuel@sortiz.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <ambx1@neo.rr.com>, <bjorn.helgaas@hp.com>
X-OriginalArrivalTime: 05 Jun 2007 07:18:38.0729 (UTC) FILETIME=[BCE69790:01C7A741]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, FIR and SIR are definitey mixed up. So, now could you  please
try 
> > Bjorn's patch ?
> 
> does not work.

It looks like the purpose of the patch is to provide more printouts
not to fix the problem, please mail your dmesg post-patch.

Linus
