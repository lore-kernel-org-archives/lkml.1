Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbXKCMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbXKCMJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXKCMJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:09:29 -0400
Received: from ozlabs.org ([203.10.76.45]:54738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXKCMJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:09:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18220.25662.609313.486315@cargo.ozlabs.ibm.com>
Date: Sat, 3 Nov 2007 23:06:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc
In-Reply-To: <20071103093240.GA22932@elte.hu>
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
	<20071103085420.GA14551@elte.hu>
	<20071103093240.GA22932@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> hm, i've removed it for now because it doesnt even build due toj:

*blush*

New patch coming.  Sending it to Linus via the scheduler tree sounds
fine to me.

Paul.
