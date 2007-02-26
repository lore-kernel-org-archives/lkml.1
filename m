Return-Path: <linux-kernel-owner+w=401wt.eu-S1161310AbXBZWxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310AbXBZWxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161297AbXBZWxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:53:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:35796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161312AbXBZWxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:53:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,221,1170662400"; 
   d="scan'208"; a="204313330:sNHT18949602"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] drivers/dma/: no "static inline" in C files
Date: Mon, 26 Feb 2007 15:53:29 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201709637@azsmsx413.amr.corp.intel.com>
In-Reply-To: <1172515344.5504.4.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] drivers/dma/: no "static inline" in C files
Thread-Index: AcdZ1dwYlXF6G1QBRYi17S9DEvTTbwAItNxA
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Leech, Christopher" <christopher.leech@intel.com>,
       "Adrian Bunk" <bunk@stusta.de>
Cc: "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Feb 2007 22:53:20.0139 (UTC) FILETIME=[E92165B0:01C759F8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Adrian,
> 
> Dan, this applies to your code.  Mind adding it to your tree?
> 
> - Chris
> 
> 
> On Sun, 2007-02-25 at 15:16 -0800, Adrian Bunk wrote:
> 
> This patch changes "static inline"s in C files to "static":
> gcc should know best whether or not to inline a static function.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
Applied.

--
Dan
