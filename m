Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYHBV4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYHBV4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYHBV4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:56:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:37838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYHBV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:56:36 -0400
Date: Sat, 2 Aug 2008 14:56:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Pinter <pinter.oliver.villany@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org, w@1wt.eu,
       Roland McGrath <roland@redhat.com>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: Re: [RFC, 2.6.26.2-rc1] posix timers: release_posix_timer: kill the
 bogus put_task_struct(->it_process)
Message-ID: <20080802145630.58279c93@infradead.org>
In-Reply-To: <200808022345.20963.oliver.pntr@gmail.com>
References: <200808022345.20963.oliver.pntr@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 23:45:20 +0200
Oliver Pinter <pinter.oliver.villany@gmail.com> wrote:

> It is an RFC for sending this patch for stable, when this patch
> needed, then send ACK and CC stable, if not then send NAK.


what is the bugzilla number or oops / bug description associated with
this one?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
