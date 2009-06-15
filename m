Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbZFOS2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbZFOS2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZFOS2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:28:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:18106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZFOS23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:28:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,224,1243839600"; 
   d="scan'208";a="699550446"
From: "Luck, Tony" <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Amerigo Wang <amwang@redhat.com>,
       "alex@shark-linux.de" <alex@shark-linux.de>,
       David Miller <davem@davemloft.net>, "rth@twiddle.net" <rth@twiddle.net>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Date: Mon, 15 Jun 2009 11:28:31 -0700
Subject: RE: [PULL] module and parameter
Thread-Topic: [PULL] module and parameter
Thread-Index: AcnsH040VscD5zRBQl6OJzijwee2WQBx5BsA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A8A79A2A@orsmsx505.amr.corp.intel.com>
References: <200906122205.57362.rusty@rustcorp.com.au>
 <12c511ca0906121405x5ccd0a60k4b804266a87a7896@mail.gmail.com>
 <200906131450.16211.rusty@rustcorp.com.au>
 <200906132135.32552.rusty@rustcorp.com.au>
In-Reply-To: <200906132135.32552.rusty@rustcorp.com.au>
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

> While I've got your attention, there was another build break on ia64 in
> linux-next, caused by removal of smp_call_function_mask.

Your fix made it into next-20090615 ... so I didn't ever see this problem.

-Tony
