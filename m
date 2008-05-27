Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYE0Pi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYE0Pi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYE0PiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:38:19 -0400
Received: from www.tglx.de ([62.245.132.106]:51460 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbYE0PiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:38:18 -0400
Date: Tue, 27 May 2008 17:36:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Michael Ellerman <michael@ellerman.id.au>,
       proski@gnu.org, a.p.zijlstra@chello.nl, Pekka Paalanen <pq@iki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, paulus@samba.org
Subject: Re: [PATCH] ftrace: powerpc clean ups
In-Reply-To: <Pine.LNX.4.58.0805221429020.18018@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805271736240.3295@apollo.tec.linutronix.de>
References: <20080515034942.109223655@goodmis.org>  <20080515035918.896765954@goodmis.org> <1211292277.7960.8.camel@localhost> <Pine.LNX.4.58.0805221429020.18018@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Steven Rostedt wrote:
> 
> This patch cleans up the ftrace code in PowerPC based on the comments from
> Michael Ellerman.

Applied, thanks

	 tglx
