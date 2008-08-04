Return-Path: <linux-kernel-owner+w=401wt.eu-S1764200AbYHDWxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764200AbYHDWxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbYHDWxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:53:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:32550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726AbYHDWxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="425936242"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 15:53:03 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2g+OJs5W/BU5oQ8GX1xUcgo9yfAAALCrw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3083291DF@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
 <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
 <20080804224533.GC30096@us.ibm.com>
In-Reply-To: <20080804224533.GC30096@us.ibm.com>
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

> Would you like me to test this patch on the box, to verify? It seems
> like you were able to reproduce the non-booting kernel?

As soon as I turned on CONFIG_PRINTK_TIME=y I hit what I presume
was the same problem.

If you have time to do so, then confirming that this is the
same issue that you are seeing on your system would be good.

Thanks

-Tony
