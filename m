Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZJZBx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZJZBx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZJZBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:53:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:5537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZJZBx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,622,1249282800"; 
   d="scan'208";a="203446177"
Date: Mon, 26 Oct 2009 09:53:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       GeunSik Lim <leemgs1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL v2,
	headers to Dual BSD/GPL
Message-ID: <20091026015357.GA6033@localhost>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 05:03:52AM +0800, Jesper Juhl wrote:
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

Me too.

Thanks,
Fengguang
