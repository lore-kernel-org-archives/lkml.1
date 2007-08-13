Return-Path: <linux-kernel-owner+w=401wt.eu-S936806AbXHMXl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936806AbXHMXl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbXHMXlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:41:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:60714 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449AbXHMXlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,257,1183359600"; 
   d="scan'208";a="117125576"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] [429/2many] MAINTAINERS - SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
Date: Mon, 13 Aug 2007 16:41:11 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0229F782@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46bffbb8.4fakUMLGtqE0GdFV%joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [429/2many] MAINTAINERS - SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
Thread-Index: Acfd+knAURocl4VlSMmxaj/P2O0rlAACOu9w
References: <46bffbb8.4fakUMLGtqE0GdFV%joe@perches.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: <joe@perches.com>, <torvalds@linux-foundation.org>, <pfg@sgi.com>,
       <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <akpm@linux-foundation.org>
Cc: <pfg@sgi.com>
X-OriginalArrivalTime: 13 Aug 2007 23:41:12.0617 (UTC) FILETIME=[6EA8C190:01C7DE03]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


@@ -4084,6 +4084,7 @@ P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-ia64@vger.kernel.org
 S:	Supported
+F:	Documentation/ia64/serial.txt
 
 SGI VISUAL WORKSTATION 320 AND 540
 P:	Andrey Panin


Huh?  Perhaps this should be:

+F:	drivers/serial/sn_console.c

-Tony
