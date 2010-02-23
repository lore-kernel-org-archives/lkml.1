Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0BWUiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:38:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0BWUiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:38:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch 3/3] x86, ptrace: remove set_stopped_child_used_math() in [x]fpregs_set
In-Reply-To: Suresh Siddha's message of  Monday, 22 February 2010 14:51:34 -0800 <20100222225240.642169080@sbs-t61.sc.intel.com>
References: <20100222225240.397523600@sbs-t61.sc.intel.com>
	<20100222225240.642169080@sbs-t61.sc.intel.com>
X-Shopping-List: (1) Ubiquitous flakes
   (2) Indigenous tables
   (3) Presidential hot pink piano malnutrition
   (4) Vivacious pubescent cancer
Message-Id: <20100223203736.F11D064C@magilla.sf.frob.com>
Date: Tue, 23 Feb 2010 12:37:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
