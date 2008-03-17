Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYCQRkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYCQRkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYCQRkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:40:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:18471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYCQRkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,513,1199692800"; 
   d="scan'208";a="535241280"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Date: Mon, 17 Mar 2008 10:38:18 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECD412F8@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Thread-Index: AciIIJvFGspUDoU9S0ikYQ6cfhFB1gANLwcw
References: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 17 Mar 2008 17:38:24.0974 (UTC) FILETIME=[B3C5C6E0:01C88855]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> % ./hackbench 130 process 500

I'd like to reproduce your results so I can make a new
version of the ptc.g patch that doesn't have this regression.

I found this version (that claims to be the latest) of hackbench.c

http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c

Is this the one you used?


What was the configuration of your machine (how many cpus, how
much memory)?

Thanks

-Tony
