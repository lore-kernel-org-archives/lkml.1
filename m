Return-Path: <linux-kernel-owner+w=401wt.eu-S935900AbYD1Rkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935900AbYD1Rkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935311AbYD1RkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:40:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:4592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935190AbYD1RkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:40:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="322228340"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-mimeole: Produced By Microsoft Exchange V6.5
Subject: RE: [stable] [PATCH] ARCH 2.6.25.y: Fix 32-bit x86 MSI-Xallocation leakage
Date: Mon, 28 Apr 2008 10:39:57 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32904F9EA21@orsmsx414.amr.corp.intel.com>
In-Reply-To: <20080428173801.GA933@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [stable] [PATCH] ARCH 2.6.25.y: Fix 32-bit x86 MSI-Xallocation leakage
Thread-Index: AcipVqew/HOYmOsaRzyZst3rqGDuQQAABTlw
References: <20080426010025.7212.3940.stgit@scrappy.jf.intel.com> <20080428173801.GA933@kroah.com>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Greg KH" <greg@kroah.com>
Cc: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2008 17:39:54.0604 (UTC) FILETIME=[DE8BBAC0:01C8A956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When sending patches to -stable, please add "CC: stable 
> <stable@kernel.org> to the patch itself in the signed-off-by 
> area, that way we get notified automatically when it goes 
> into Linus's tree so that we can then know to apply it to the 
> tree.  Otherwise it's a tough job to try to track all of 
> these knowing when to watch out for them to be committed.
> 
> Can you please resend them to stable@kernel.org when they do 
> go into Linus's tree?

Sure thing.

Thanks Greg,

-PJ Waskiewicz
