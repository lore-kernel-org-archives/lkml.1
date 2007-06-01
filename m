Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXFAIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXFAIAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXFAIAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:00:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:13102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXFAIAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:00:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,371,1175497200"; 
   d="scan'208";a="252028297"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Fri, 1 Jun 2007 01:00:33 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01961AFE@scsmsx411.amr.corp.intel.com>
In-Reply-To: <465F9315.2050207@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: Acej/VwDhjyj54hsQCKIWtqy/uQnDwAJVLuA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Prarit Bhargava" <prarit@redhat.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "David Chinner" <dgc@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 01 Jun 2007 08:00:36.0100 (UTC) FILETIME=[EFB7EC40:01C7A422]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I used the sn2_defconfig in the tree :)

So there is something odd happening.  Russ complained that he
was still seeing several errors from the sn2_defconfig build
too when I posted the "last fix" to Len.  But I don't see them
when I build.

-Tony
