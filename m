Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYKYKYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYKYKYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYKYKYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:24:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:22090 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKYKYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:24:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="82359522"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
Date: Tue, 25 Nov 2008 10:24:13 +0000
Subject: RE: [patch 7/9] x86, pebs: export ds.c symbols
Thread-Topic: [patch 7/9] x86, pebs: export ds.c symbols
Thread-Index: AclO3gR0K89A1ov2Q8OtQgq+ejSM8wACcQxw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F3C31E@irsmsx504.ger.corp.intel.com>
References: <20081125090847.A31384@sedona.ch.intel.com>
 <20081125082603.GB28031@infradead.org> <20081125091229.GA22027@elte.hu>
In-Reply-To: <20081125091229.GA22027@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Dienstag, 25. November 2008 10:12
>To: Christoph Hellwig
>Cc: Metzger, Markus T; hpa@zytor.com; 

>* Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Tue, Nov 25, 2008 at 09:08:47AM +0100, Markus Metzger wrote:
>> > Export symbols in ds.c.
>> > 
>> > The changes are required to allow perfmon2 to access DS.
>> 
>> So put them into the perform2 patchset.
>
>yes - and they need to be EXPORT_SYMBOL_GPL() as well.

OK.

I will send a patch to Stephane, then, so he can include it into the perfmon2 series.


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

