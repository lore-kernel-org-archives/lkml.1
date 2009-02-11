Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZBKObs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZBKObs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZBKObi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:31:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZBKObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:31:37 -0500
Date: Wed, 11 Feb 2009 09:31:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] git pull request for tip/tracing/ftace
In-Reply-To: <20090211091002.GH21105@elte.hu>
Message-ID: <alpine.DEB.1.10.0902110930150.8617@gandalf.stny.rr.com>
References: <20090210173504.973802731@goodmis.org> <20090211091002.GH21105@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Ingo Molnar wrote:
> Note, i cherry-picked this fix into tip:tracing/urgent:
> 
>   9666578: tracing, x86: fix constraint for parent variable
> 
> As in theory GCC can miscompile the function-return-tracer, right?

Yeah, I was thinking that, but I could not make it do so with the few 
test cases that I tried. But in theory, I guess it can.

-- Steve

