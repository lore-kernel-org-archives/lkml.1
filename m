Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYKATMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYKATMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYKATM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:12:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYKATM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:12:28 -0400
Date: Sat, 1 Nov 2008 15:12:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: sysrq-z to dump the buffers
In-Reply-To: <1225565614.21456.48.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0811011512090.13528@gandalf.stny.rr.com>
References: <1225565614.21456.48.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 1 Nov 2008, Peter Zijlstra wrote:

> Allows one to force an ftrace dump from sysrq
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

