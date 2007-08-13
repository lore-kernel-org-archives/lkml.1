Return-Path: <linux-kernel-owner+w=401wt.eu-S1032591AbXHMRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032591AbXHMRju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938680AbXHMRhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:37:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:2834 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031548AbXHMRha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:37:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="278252297"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: kvm warning
Date: Mon, 13 Aug 2007 10:37:22 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224CFEF@scsmsx411.amr.corp.intel.com>
In-Reply-To: <a781481a0708131031k7e2bcc18t3fd0e7709e14d4a2@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kvm warning
Thread-Index: Acfdz9oNLzzV+7euRBWIgTxPaSwI7AAAJSbA
References: <20070808151446.9a4eebda.akpm@linux-foundation.org> <20070808221956.GA16238@elte.hu> <46BA4827.3080907@qumranet.com> <20070808155901.bcb249d9.akpm@linux-foundation.org> <46BA4D12.8090301@qumranet.com> <a781481a0708131031k7e2bcc18t3fd0e7709e14d4a2@mail.gmail.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>, "Avi Kivity" <avi@qumranet.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Aug 2007 17:37:23.0934 (UTC) FILETIME=[9BC00FE0:01C7DDD0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Solution (1) above sounds preferable, unless there are mysterious reasons
> why ia64 wants to avoid Kconfig.preempt (adding Tony Luck to Cc:).

Send me a patch and unless it causes more problems than it solves, I'll
put it in.

-Tony
