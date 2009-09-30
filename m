Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZI3Ub6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZI3Ub6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZI3Ub5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:31:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:39061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZI3Ub5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,481,1249282800"; 
   d="scan'208";a="498591011"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <teheo@suse.de>, Nick Piggin <npiggin@suse.de>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2009 13:32:00 -0700
Subject: RE: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
 percpu and drop the old one, take#2
Thread-Topic: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
 percpu and drop the old one, take#2
Thread-Index: AcpAm1elVAfd0CArQGmD1n/gtd5k2QBcYFEA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E2F03E58@orsmsx505.amr.corp.intel.com>
References: <1253682382-24740-1-git-send-email-tj@kernel.org>
 <4AC153EA.2050007@suse.de>
In-Reply-To: <4AC153EA.2050007@suse.de>
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

> Tony, can you please ack ia64 part?

Tejun,

Ok. The new patchset builda and boots for both the contig.c and discontig.c
versions of the kernel.

Acked-by; Tony Luck <tony.luck@intel.com>
