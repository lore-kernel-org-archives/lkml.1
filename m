Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZE1Vhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZE1Vhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZE1Vho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:37:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:25563 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZE1Vho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,267,1241420400"; 
   d="scan'208";a="461303920"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "arnd@arndb.de" <arnd@arndb.de>,
       "joerg.roedel@amd.com" <joerg.roedel@amd.com>
Date: Thu, 28 May 2009 14:37:37 -0700
Subject: RE: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
Thread-Topic: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
Thread-Index: AcnfcnYWcnucFUUARR+bXZ0vyrNfgwAZJB0w
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A8738DE2@orsmsx505.amr.corp.intel.com>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20090528002020.8b68f085.akpm@linux-foundation.org>
 <20090528163853Q.fujita.tomonori@lab.ntt.co.jp>
 <20090528085810.GA24335@elte.hu>
In-Reply-To: <20090528085810.GA24335@elte.hu>
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

> > > Alternatively I can merge the lot, with suitable acking.
> >
> > It would be easier, I think.
>
> Yeah, that's certainly fine with me. No sense pulling these apart.

Part 5/5 (cleaning up long long warnings) is about to be made
irrelevent.  I have Matthew Wilcox's patch to switch ia64 over
to using <asm-generic/int-ll64.h> queued up (its in linux-next
already).

Other parts

Acked-by: Tony Luck <tony.luck@intel.com>
