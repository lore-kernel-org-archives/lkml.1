Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZIVVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZIVVYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZIVVYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:24:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:46028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZIVVYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:24:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,433,1249282800"; 
   d="scan'208";a="495909488"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2009 14:24:30 -0700
Subject: RE: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
	percpu and drop the old one
Thread-Topic: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic
	percpu and drop the old one
Thread-Index: Aco7XQHoshjCJG79TD652cfgIyS8vgAaKYnAAAB/+dAAAIf3YA==
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E29CCB18@orsmsx505.amr.corp.intel.com>
References: <1253605214-23210-1-git-send-email-tj@kernel.org>
 <20090922081631.GD1475@elte.hu>
 <57C9024A16AD2D4C97DC78E552063EA3E29CCA8E@orsmsx505.amr.corp.intel.com>
 <57C9024A16AD2D4C97DC78E552063EA3E29CCADC@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E29CCADC@orsmsx505.amr.corp.intel.com>
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

I just noticed the "#for-next" in the Subject line for these
patches.  Do they depend on some stuff in linux-next that is
not in Linus' tree (pulled today HEAD=7fa07729e...)?  If so, then
ignore my results.

Kernel built from generic_defconfig does boot OK though, so I suspect
this is a discontig vs. contig problem.

-Tony
