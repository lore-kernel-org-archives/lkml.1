Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZJXV1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZJXV1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 17:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZJXV1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 17:27:03 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:58586 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZJXV1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 17:27:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAJ8I40pGGN1W/2dsb2JhbACBUNNihD8E
Date: Sat, 24 Oct 2009 17:22:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Adrian Bunk <bunk@stusta.de>, Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       GeunSik Lim <leemgs1@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,
	headers to Dual BSD/GPL
Message-ID: <20091024212201.GA18184@Krystal>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:20:56 up 67 days,  8:10,  2 users,  load average: 0.05, 0.12,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jj@chaosbits.net) wrote:
> On Fri, 23 Oct 2009, Mathieu Desnoyers wrote:
> 
> > (updated email for Jesper Juhl)
> > 
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > Hi,
> > > 
> > > I would like to re-license the tracepoint.c/marker.c files from GPL to:
> > > 
> > > * Dual LGPL v2.1/GPL v2 license.
> > > 
> > > And re-license tracepoint.h/marker.h to:
> > > 
> > > * Dual BSD/GPL v2 license.
> > > 
> > > The goal is to allow sharing code between the kernel tracer and UST
> > > (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
> > > and marker headers might need to be included by proprietary or BSD
> > > applications, hence the dual BSD/GPL v2 license for these two.
> > > 
> > > I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
> > > which includes Zhao Lei and Lai Jiangshan.
> > > 
> > > The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
> > > 
> > > For tracepoint.c:
> > > 
> > > Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > 
> > > For marker.c:
> > > 
> > > "Robert P. J. Day" <rpjday@mindspring.com>
> > > Adrian Bunk <bunk@stusta.de>
> > > Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Jesper Juhl <jj@chaosbits.net>
> > 
> 
> I don't think I have enough significant changes in there to actually 
> require my approval for relicensing, but since you ask; I personally 
> do not have a problem with that file being Dual LGPL v2.1/GPL v2 
> licensed.

I wonder if trivial one-liners and cleanups require the approval from
the contributors. In doubt, I prefer to ask. But you might be right that
it's not actually needed.

Thanks!

Mathieu

> 
> -- 
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
