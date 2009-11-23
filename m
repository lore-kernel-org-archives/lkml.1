Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZKWXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZKWXBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZKWXBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbZKWXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:01:19 -0500
Date: Mon, 23 Nov 2009 18:00:22 -0500
From: Jason Baron <jbaron@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 0/3] tracepoint: Add signal events
Message-ID: <20091123230022.GA2744@redhat.com>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 04:31:08PM -0500, Masami Hiramatsu wrote:
> Hi,
> 
> These patches add signal related tracepoints including
> signal generation, delivery, and loss. First patch also
> moves signal-sending tracepoint from events/sched.h to
> events/signal.h.
> 
> Changes in v3
> - Add Docbook style comments
> 

Documentation bits look good. thanks for adding them.

Reviewed-by: Jason Baron <jbaron@redhat.com>
