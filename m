Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXB1OtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXB1OtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXB1OtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:49:09 -0500
Received: from sdcsmtp.europe.hp.net ([15.203.169.187]:53158 "EHLO
	sdcrelbas01.sdc.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932432AbXB1OtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:49:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 15:51:39 +0100
Message-ID: <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <45E593C2.6020004@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: lanana: Add major/minor entries for PPC QE UART devices
Thread-Index: AcdbRg+b/GsC6YmPR8ird4RsZVgtAQAATr0Q
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net> <45E593C2.6020004@freescale.com>
From: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
To: "Timur Tabi" <timur@freescale.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Feb 2007 14:49:07.0547 (UTC) FILETIME=[99432AB0:01C75B47]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Mathiasen, Torben wrote:
> 
> > Assuming QE has 4 entries, I would expect CPM to be the same. But we
> > need verification of that. If it needs 6, we are in more trouble.
> 
> The QE can have up to 8, actually, but I'm willing to limit the driver
> to 4.

Its your choice if you want to limit it to 4 or have it moved into a
different minor range. I can live with both.

Thanks,
Torben
