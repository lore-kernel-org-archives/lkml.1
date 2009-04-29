Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZD2BFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZD2BFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZD2BFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:05:44 -0400
Received: from host2.marvell.com ([65.219.4.2]:6099 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755311AbZD2BFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:05:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date: Tue, 28 Apr 2009 18:14:59 -0700
Subject: RE: BUG: sleeping function called from invalid context at
 mm/slub.c:1595 --- "hcitool cc" or "l2ping"
Thread-Topic: BUG: sleeping function called from invalid context at
 mm/slub.c:1595 --- "hcitool cc" or "l2ping"
Thread-Index: AcnIZpY7EbExf/2aSEacDZ40Vn3fwgAAJ2Iw
Message-ID: <477F20668A386D41ADCC57781B1F704301E3F5C7FC@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F704301E3F5C7F5@SC-VEXCH1.marvell.com>
 <1240966565.997.65.camel@localhost.localdomain>
In-Reply-To: <1240966565.997.65.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Apr 2009 01:05:43.0840 (UTC) FILETIME=[9F1BFA00:01C9C866]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Bing,
> 
> > I'm getting this error whenever I use "hcitool cc" or "l2ping xx:xx:xx:xx:xx:xx"
> command.
> >
> > Kernel: version 2.6.30-rc3 from bluetooth-testing tree
> > HCI Tool: version 3.20
> > Laptop: Lenovo X61s
> 
> can you rebase the bluetooth-testing.git tree from a few hours ago and
> test again.
> 
> Regards
> 
> Marcel
> 

Hi Marcel,

"git log" shows the last commit was ad4751fcada51292bb2967748667b582281647d0.
Bluetooth: Fix errors and warnings in L2CAP reported by checkpatch.pl

Is it the latest one?

Thanks,

Bing




