Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZD2Npj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZD2Npj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZD2Npa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:45:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZD2Npa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:45:30 -0400
Date: Wed, 29 Apr 2009 09:45:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
 for per worklet
In-Reply-To: <20090429133342.GA5987@nowhere>
Message-ID: <alpine.DEB.2.00.0904290944290.8066@gandalf.stny.rr.com>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org> <20090429133342.GA5987@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Apr 2009, Frederic Weisbecker wrote:
>  * pointer to the real address.
> 
> But the output formatting is the same: address, offset, size, modname.
> 
> I found it a bit annoying, so I proposed the following patch recently:
> 
> http://lkml.org/lkml/2009/4/15/310
> 
> And someone came with a better idea, IMO:
> 
> http://lkml.org/lkml/2009/4/17/105

Note,

If these ever do get merged, I would be happy to convert ftrace to use 
them to replace my version.

-- Steve

