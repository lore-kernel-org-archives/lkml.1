Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZHGLhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZHGLhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHGLhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:37:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:60731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZHGLhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,341,1246863600"; 
   d="scan'208";a="714754668"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 Aug 2009 12:37:42 +0100
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Topic: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Index: AcoXUQDlO2l7mf6tTTqOwLuV7Qbv8AAAlULg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF06B@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
 <20090804113555.GA28198@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
 <1249633282.32113.613.camel@twins>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
 <20090807111949.GA30014@elte.hu>
In-Reply-To: <20090807111949.GA30014@elte.hu>
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
>Sent: Friday, August 07, 2009 1:20 PM
>To: Metzger, Markus T
>Cc: Peter Zijlstra; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
>
>
>note, i had this running in the background, as root:
>
>/home/mingo/bin/perf top >/dev/null 2>/dev/null&


I can reproduce the kernel hang in that case.

I'll look into it.

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

