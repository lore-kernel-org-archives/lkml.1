Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZD1Qnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZD1Qnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZD1Qn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:43:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZD1Qn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:43:26 -0400
Date: Tue, 28 Apr 2009 12:43:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
In-Reply-To: <20090428163300.GD5978@nowhere>
Message-ID: <alpine.DEB.2.00.0904281242380.8066@gandalf.stny.rr.com>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu> <20090428154046.GA32381@Krystal> <20090428163300.GD5978@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Apr 2009, Frederic Weisbecker wrote:
> 
> I don't know why I used irqsave here, I guess I was tired.

It was the "when in doubt use irqsave", or was it the "I don't want to 
think about it, use irqsave" ;-)

-- Steve

