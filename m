Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXFADSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXFADSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 23:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXFADSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 23:18:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbXFADSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 23:18:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,371,1175497200"; 
   d="scan'208";a="251960012"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Thu, 31 May 2007 20:18:42 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01961A60@scsmsx411.amr.corp.intel.com>
In-Reply-To: <465EE7BB.4050605@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: Acejlzwp7CQXH85kSYambu4kxN+ErwAZCdKw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Prarit Bhargava" <prarit@redhat.com>,
       "Christoph Lameter" <clameter@sgi.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, "David Chinner" <dgc@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 01 Jun 2007 03:18:43.0131 (UTC) FILETIME=[8ECDA8B0:01C7A3FB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, the ia64 section mismatch "whack-a-mole" is far from over :(

Can you post the .config file that you are using when you see all those
warnings ... I'll start bopping them on their cute little heads.

-Tony
