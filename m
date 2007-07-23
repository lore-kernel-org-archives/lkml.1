Return-Path: <linux-kernel-owner+w=401wt.eu-S1765244AbXGWQId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765244AbXGWQId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763045AbXGWQF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:05:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:50653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763628AbXGWQF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,571,1175497200"; 
   d="scan'208";a="108965571"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: drivers/dma/ioatdma.c - address of '__this_module' will always evaluate as 'true' , warning
Date: Mon, 23 Jul 2007 09:05:54 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
In-Reply-To: <46A3FE3E.20300@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/dma/ioatdma.c - address of '__this_module' will always evaluate as 'true' , warning
Thread-Index: AcfMxYpRJGOFCmAvRlO2Dm6k5AV1jQAfZXnA
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Gabriel C" <nix.or.die@googlemail.com>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 16:05:55.0238 (UTC) FILETIME=[598EC460:01C7CD43]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C [mailto:nix.or.die@googlemail.com] 
>
>Hi,
>
>I got this warning on current git using gcc 4.2.1 :
>
>...
>
>drivers/dma/ioatdma.c: In function 'ioat_init_module':
>drivers/dma/ioatdma.c:816: warning: the address of 
>'__this_module' will always evaluate as 'true'

Can you forward a copy of your .config?

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
