Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZLIRsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZLIRsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZLIRsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:48:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:40572 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZLIRsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:48:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,369,1257148800"; 
   d="scan'208";a="521312185"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Dec 2009 09:48:19 -0800
Subject: RE: [PATCH] mm/vmalloc: don't use vmalloc_end
Thread-Topic: [PATCH] mm/vmalloc: don't use vmalloc_end
Thread-Index: Acp49W7oim8DhBK1SxqeicNjrg0mbwAAiYJg
Message-ID: <4BDB13256095B24D9644F65379E6042656CFE088@orsmsx505.amr.corp.intel.com>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
 <20091207153552.0fadf335.akpm@linux-foundation.org>
 <4B1E1B1B0200007800024345@vpn.id2.novell.com>
 <alpine.DEB.2.00.0912091128280.16491@router.home>
In-Reply-To: <alpine.DEB.2.00.0912091128280.16491@router.home>
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

> Tony: Can you confirm that the new percpu stuff works on IA64.

If all the pieces are in (either Linus tree, or linux-next) then
it is working (well these both still build & boot on my test systems).

-Tony
