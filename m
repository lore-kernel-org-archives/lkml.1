Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700Ab0A3IrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0A3IrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 03:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408Ab0A3IrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 03:47:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0A3IrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 03:47:19 -0500
Subject: Re: Lock dependency based tree report in perf lock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100129231723.GB5052@nowhere>
References: <20100129231723.GB5052@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 09:46:28 +0100
Message-ID: <1264841188.24455.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 00:17 +0100, Frederic Weisbecker wrote:
> 
> 
> Anyway, that's just an idea, not trivial I must admit.

lockdep actually collects all this information, so writing it out isn't
too hard.



