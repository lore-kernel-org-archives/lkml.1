Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108Ab0ATIxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0ATIxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984Ab0ATIxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:53:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0ATIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:53:15 -0500
Subject: Re: linux-next: add utrace tree
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20100120062834.GB12165@elte.hu>
References: <20100119211646.GF16096@redhat.com>
	 <20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	 <20100120054950.GB27108@elte.hu> <20100120061551.GB6588@in.ibm.com>
	 <20100120062834.GB12165@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 09:52:52 +0100
Message-ID: <1263977572.4283.820.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 07:28 +0100, Ingo Molnar wrote:
> > I think Oleg addressed most of Peter's concerns on utrace when the 
> > ptrace/utrace patchset was reposted.
> 
> Peter is Cc:-ed and he might want to chime in.

Yeah, I'll make some time to go through the latest code again.. if only
there was a clone() for humans ;-)

