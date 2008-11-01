Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYKATYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYKATYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYKATX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:23:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYKATX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:23:57 -0400
Subject: Re: [PATCH] ftrace: sysrq-z to dump the buffers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811011512090.13528@gandalf.stny.rr.com>
References: <1225565614.21456.48.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0811011512090.13528@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 20:22:39 +0100
Message-Id: <1225567360.21456.53.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-01 at 15:12 -0400, Steven Rostedt wrote:
> On Sat, 1 Nov 2008, Peter Zijlstra wrote:
> 
> > Allows one to force an ftrace dump from sysrq
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

needs a s/CONFIG_FTRACE/CONFIG_TRACING/ though

