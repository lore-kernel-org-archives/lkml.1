Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbYBHFlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbYBHFlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYBHFk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:40:59 -0500
Received: from bgerelbas01.asiapac.hp.net ([15.219.201.134]:50936 "EHLO
	bgerelbas01.asiapac.hp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYBHFk5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:40:57 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/7] blk_end_request: full I/O completion handler
Date: Fri, 8 Feb 2008 11:10:32 +0530
Message-ID: <77334B9413C72244AE1B51ADD4868D700AFD9D60@BGEEXC02.asiapacific.cpqcorp.net>
In-Reply-To: <20080205103851.GQ15220@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/7] blk_end_request: full I/O completion handler
Thread-Index: Achn42YrDNAZ4IGrRvCXMJx9bzvBxgCMVwkg
From: "S, Chandrakala (STSD)" <chandrakala.s@hp.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>,
       <grant.likely@secretlab.ca>, <dm-devel@redhat.com>,
       <j-nomura@ce.jp.nec.com>
X-OriginalArrivalTime: 08 Feb 2008 05:40:33.0464 (UTC) FILETIME=[1F746B80:01C86A15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the information! 
We would like to know when does the 2.6.25 kernel will be available at
kernel.org.

Thanks,
Chandrakala 

-----Original Message-----
From: Jens Axboe [mailto:jens.axboe@oracle.com] 
Sent: Tuesday, February 05, 2008 4:09 PM
To: S, Chandrakala (STSD)
Cc: Kiyoshi Ueda; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; Miller, Mike (OS
Dev); grant.likely@secretlab.ca; dm-devel@redhat.com;
j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler

On Tue, Feb 05 2008, S, Chandrakala (STSD) wrote:
> Hello,
> 
> We would like to know in which kernel version these patches are 
> available.

They were merged after 2.6.24 was released, so they will show up in the
2.6.25 kernel.

--
Jens Axboe

