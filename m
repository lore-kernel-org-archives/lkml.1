Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYJDFeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYJDFeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 01:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYJDFd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 01:33:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJDFd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 01:33:57 -0400
Date: Fri, 3 Oct 2008 22:33:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power optimization
Message-ID: <20081003223347.27aa25ba@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com>
References: <20081003165533.249261b1@infradead.org>
	<alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Hi Arjan,
> 
> Very nice! I just have a few comments below.

since this is my first tracer.... I would suggest having a "golden
example" one that people can copy (it seems I copied a less than
perfect one ;-)... maybe a trace_example.c ?

I'll look into your comments tomorrow when I'm more awake.
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
