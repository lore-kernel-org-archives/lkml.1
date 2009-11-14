Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZKNAHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZKNAHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZKNAHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbZKNAHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:07:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
In-Reply-To: Ingo Molnar's message of  Saturday, 14 November 2009 01:02:34 +0100 <20091114000234.GA24738@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
	<20091113225233.15079.41600.stgit@harusame>
	<20091113233912.192A3100E@magilla.sf.frob.com>
	<20091114000234.GA24738@elte.hu>
X-Windows: dissatisfaction guaranteed.
Message-Id: <20091114000627.48ED615E8@magilla.sf.frob.com>
Date: Fri, 13 Nov 2009 16:06:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, so SystemTap is the motivator of these tracepoints? 

Nope.  My suggestion about arguments to pass was just generic based on the
innate context of this tracepoint.

> Do you know about exact usecases where these tracepoints would be
> utilized? Would be interesting (and relevant) to list them.

Masami's colleagues do have something in particular in mind,
but I'm not sure whether they intend to use systemtap as part
of the implementation of that or not.


Thanks,
Roland
