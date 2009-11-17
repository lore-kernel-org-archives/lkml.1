Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZKQRZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZKQRZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZKQRZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:25:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:55496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbZKQRZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:25:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,759,1249282800"; 
   d="scan'208";a="747860551"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 17 Nov 2009 09:25:42 -0800
Subject: RE: [PATCH] ia64 support for tools/perf/
Thread-Topic: [PATCH] ia64 support for tools/perf/
Thread-Index: AcpnqoahkiWnc3AFQN6vOKUXAptJrgAACiZw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E3876A5B@orsmsx505.amr.corp.intel.com>
References: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
 <20091117172139.GB5967@elte.hu>
In-Reply-To: <20091117172139.GB5967@elte.hu>
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

> Btw., are you planning HAVE_PERF_EVENTS support for IA64? (It's nice 
> stuff, i can only recommend it! ;-)

My first goal is getting the s/w events hooked up and working.  I'm still
wondering about how to get the h/w counters to co-exist with perfmon (which
has been part of ia64 API for many years).

-Tony
