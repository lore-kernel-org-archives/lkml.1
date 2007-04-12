Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXDLAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXDLAlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXDLAlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:41:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:47258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbXDLAlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:41:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,397,1170662400"; 
   d="scan'208"; a="212018700:sNHT70484365"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] kernel-doc: fix plist.h comments
Date: Wed, 11 Apr 2007 17:41:18 -0700
Message-ID: <C72DEB015BA7724783363DE1AF6B0F9801AEFDEC@orsmsx417.amr.corp.intel.com>
In-Reply-To: <20070411173913.3a758a46.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kernel-doc: fix plist.h comments
Thread-Index: Acd8mp8KUhjgdH3iR0aZX1+KvWL9FQAAE8mw
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Cc: <dwalker@mvista.com>, <tglx@linutronix.de>, <oleg@tv-sign.ru>,
       "akpm" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 12 Apr 2007 00:41:19.0975 (UTC) FILETIME=[4996E770:01C77C9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Randy Dunlap <randy.dunlap@oracle.com>
>
>Make kernel-doc comments match macro names.
>Correct parameter names in a few places.
>Remove '#' from beginning of kernel-doc comment macro names.
>Remove extra (erroneous) blank lines in kernel-doc.
>
> ...
>
>cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>cc: Daniel Walker <dwalker@mvista.com>
>cc: Thomas Gleixner <tglx@linutronix.de>
>cc: Oleg Nesterov <oleg@tv-sign.ru>
>
>Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
