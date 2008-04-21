Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYDUVZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYDUVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYDUVZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:25:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYDUVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:25:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Fcc: ~/Mail/linus
Cc: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: i386 single-step vs int $0x80 issues
In-Reply-To: Jason Wessel's message of  Monday, 21 April 2008 13:00:56 -0500 <480CD658.6030801@windriver.com>
References: <20080416023650.E3CBDEFFEA@magilla.localdomain>
	<480CD658.6030801@windriver.com>
X-Zippy-Says: YOW!!  Now I understand advanced MICROBIOLOGY and th' new TAX REFORM laws!!
Message-Id: <20080421212543.15E1F26F8F0@magilla.localdomain>
Date: Mon, 21 Apr 2008 14:25:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Certainly I am interested in making all the cases work correctly.  The
> failure behavior was observed on an SMP system.  I re-tested to
> confirm the problem was still there.

Please help me reproduce this problem on the old code.  I have not been
able to see it.  You didn't say whether it was intermittent, nor give any
more details here.


Thanks,
Roland

