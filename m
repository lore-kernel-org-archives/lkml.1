Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZKXWMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZKXWMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZKXWMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:12:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067AbZKXWMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:12:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v4 0/3] tracepoint: Add signal events
In-Reply-To: Masami Hiramatsu's message of  Tuesday, 24 November 2009 16:56:38 -0500 <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
X-Shopping-List: (1) Voluminous prostitutes
   (2) Incumbent ecclesiastical rubber
   (3) Vainglorious raisins
Message-Id: <20091124221219.3417FD38A@magilla.sf.frob.com>
Date: Tue, 24 Nov 2009 14:12:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

There might be some more refinements that are worthwhile, but these look
like a sensible and clean enough set of tracepoints to start with.  If we
need to change them, that will become clear from the experiences of people
actually using these.


Thanks,
Roland
