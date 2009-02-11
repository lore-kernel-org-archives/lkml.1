Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZBKStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZBKStz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZBKStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:49:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:4659 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbZBKSto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,193,1233561600"; 
   d="scan'208";a="430181824"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Dean Nelson <dcn@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Feb 2009 10:49:41 -0800
Subject: RE: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next	tree
Thread-Topic: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next
	tree
Thread-Index: AcmMRN3+aU1QqjB7RumXWjhMqnH/6wANI7TA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA361689D41@orsmsx505.amr.corp.intel.com>
References: <20090209162520.GA4882@sgi.com> <20090211123249.GE16535@elte.hu>
In-Reply-To: <20090211123249.GE16535@elte.hu>
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

> Tony, since this breakage is an accidental side-effect of the x86 tree (that
> has to be fixed there), mind if we carry it there?

Ingo,

I don't mind at all.

-Tony
