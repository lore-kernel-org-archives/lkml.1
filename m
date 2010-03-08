Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0CHIBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:01:52 -0500
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:12175 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CHIBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:01:51 -0500
X-Greylist: delayed 3486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 03:01:51 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Failed to alloc 4M DMA memory in the 256M system
Date: Mon, 8 Mar 2010 15:02:43 +0800
Message-ID: <2234BBB33B4B2048B28E3B3ACFC9795C01A6792D@CNBEEXC007.nsn-intra.net>
In-Reply-To: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Failed to alloc 4M DMA memory in the 256M system
Thread-Index: Acq+jExpAL0SZP0dR3SnfSyxlPGVNQAAG/7g
References: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
From: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Mar 2010 07:03:43.0144 (UTC) FILETIME=[7D116A80:01CABE8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All:

I try to alloc 4M memory for the DMA purpose in the 256M system running
V2.6.29. But failed.

I check the system, there is no 4M DMA memory in the DMA zone free list
indeed, So I'd like to
ask for that Is it possible for me to alloc 4M(or larger) DMA memory in
the linux system. 
if YES, HOW?

I forgot to say my hardware is based on X86. 

Thank you in advance.
