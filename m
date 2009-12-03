Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZLCPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZLCPDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZLCPDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:03:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:27768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbZLCPDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:03:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,335,1257148800"; 
   d="scan'208";a="575336765"
From: "Ma, Ling" <ling.ma@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 3 Dec 2009 23:03:15 +0800
Subject: RE: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Thread-Topic: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Thread-Index: Acpybt6zMpQxUWWgS62glBvsAEJUkQBucmPQ
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FF5709D9@PDSMSX501.ccr.corp.intel.com>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
	<20091126094930.GD32275@elte.hu>
	<8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
 <20091201021459.43d2142a@infradead.org>
In-Reply-To: <20091201021459.43d2142a@infradead.org>
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

> a key question is.. how much more memory do you have free due to -Os?
> (because memory is cache is performance on a system level as well)
The kernel code size from Os is 12M, that from O2 is 14M.
> and how much less icache pressure is there?
>From perf stat report, cache reference(unified cache) from O2 is almost the same with Os.

Thanks
Ling 

