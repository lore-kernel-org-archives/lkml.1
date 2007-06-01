Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbXFAKh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbXFAKh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758318AbXFAKhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:37:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:32067 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbXFAKhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:37:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,372,1175497200"; 
   d="scan'208";a="234458031"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Fri, 1 Jun 2007 03:37:09 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01961B11@scsmsx411.amr.corp.intel.com>
In-Reply-To: <465FF539.6090506@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AcekN9vxAun6Z8lGSAuii5GtIZ94sQAAMxyg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Prarit Bhargava" <prarit@redhat.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "David Chinner" <dgc@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Vivek Goyal" <vgoyal@in.ibm.com>
X-OriginalArrivalTime: 01 Jun 2007 10:37:10.0730 (UTC) FILETIME=[CF5AB2A0:01C7A438]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, what system are you using to compile on, OS, etc?

$ cat /etc/redhat-release
Red Hat Enterprise Linux AS release 4 (Nahant Update 5 Beta)

-Tony
