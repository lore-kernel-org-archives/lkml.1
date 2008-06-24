Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYFXSAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYFXSAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYFXR74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:59:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:54028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYFXR7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,697,1204531200"; 
   d="scan'208";a="299066434"
From: "Luck, Tony" <tony.luck@intel.com>
To: Julia Lawall <julia@diku.dk>
CC: "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 24 Jun 2008 10:59:51 -0700
Subject: RE: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Topic: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Index: AcjWI4y8U2AV0VIcSmiY5rtkez5B5wAAD8ZQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3062D2488@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
 <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
 <Pine.LNX.4.64.0806241948120.26777@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0806241948120.26777@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There is no commit b1fceac2b9e04d278316b2faddf276015fc06e3b in Linus' tree.
>
> I am not sure to know how to tell precisely where you are looking, but you
> can find it here:

You are right ... I'm not at all sure where I was looking either.  I cut
& pasted the commit to a "git show ....", and it came up with nothing.  But
now it works!  Some strange user error on my part.  Sorry.

-Tony
