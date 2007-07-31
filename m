Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbXGaQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbXGaQyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765429AbXGaQyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:29404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817AbXGaQyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="111843649"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: regression on HP zx1 platform from ACPI autoload modulespatches
Date: Tue, 31 Jul 2007 09:54:05 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A020E3B4F@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1185900042.18821.213.camel@queen.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: regression on HP zx1 platform from ACPI autoload modulespatches
Thread-Index: AcfTkY1QyskEpXUpSyC0ywAHmuFJKAAARiZQ
From: "Luck, Tony" <tony.luck@intel.com>
To: <trenn@suse.de>
Cc: "Doug Chapman" <doug.chapman@hp.com>, "Tony Luck" <tony.luck@gmail.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 31 Jul 2007 16:54:05.0843 (UTC) FILETIME=[67CC1630:01C7D393]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, it looks like the patch has not hit Linus tree yet:


Huh?  I can see it in his tree via gitweb.  Here's the patch:

	http://tinyurl.com/3csnu6

and the raw "blob" for sba_iommu.c:

	http://tinyurl.com/397cy6

[Scroll down to line 2018 and you'll see the new code in place].

Something very odd is happening.

-Tony
