Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0BDCSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:18:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0BDCSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:18:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Lu, Hongjiu" <hongjiu.lu@intel.com>
X-Fcc: ~/Mail/linus
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lachner, Peter" <peter.lachner@intel.com>
Subject: RE: [patch] x86: ptrace and core-dump extensions for xstate
In-Reply-To: Lu, Hongjiu's message of  Wednesday, 3 February 2010 18:05:11 -0800 <8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	<20100203230817.E6529AA@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB0AE@orsmsx504.amr.corp.intel.com>
	<20100204020224.45379725@magilla.sf.frob.com>
	<8EA2C2C4116BF44AB370468FBF85A7770123AAB2E8@orsmsx504.amr.corp.intel.com>
Emacs: the answer to the world surplus of CPU cycles.
Message-Id: <20100204021659.AB348C880@magilla.sf.frob.com>
Date: Wed,  3 Feb 2010 18:16:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is how processor works.

We're not talking about the processor.  
We're talking about the API of a Linux system call.


Thanks,
Roland
