Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbYJJQza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbYJJQza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYJJQzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:55:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbYJJQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:55:16 -0400
Date: Fri, 10 Oct 2008 12:55:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] tracepoint: Check if the probe has been registered
In-Reply-To: <alpine.DEB.1.10.0810101252320.21101@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810101254360.21101@gandalf.stny.rr.com>
References: <20081010111631.78545D1BDA2@perso1.free.fr> <20081010140023.GA13137@elte.hu> <alpine.DEB.1.10.0810101252320.21101@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Oct 2008, Steven Rostedt wrote:
> > 
> > Mathieu, Steve, any objections/observations?
> 
> Hmm, my email was on the fritz for this one. I'll have to search for it on 
> a mailing list web site to see the patch.


OK, found it at 
http://groups.google.com/group/linux.kernel/browse_thread/thread/9519141803211fee/70a273bb6a1ea602?lnk=raot

Looks good for me too.

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

