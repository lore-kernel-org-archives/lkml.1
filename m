Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZJXVLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZJXVLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 17:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZJXVLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 17:11:22 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21267 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZJXVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 17:11:21 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Oct 2009 17:11:21 EDT
Date: Sat, 24 Oct 2009 23:03:52 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Adrian Bunk <bunk@stusta.de>, Harvey Harrison <harvey.harrison@gmail.com>,
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
In-Reply-To: <20091023160632.GA2198@Krystal>
Message-ID: <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009, Mathieu Desnoyers wrote:

> (updated email for Jesper Juhl)
> 
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > Hi,
> > 
> > I would like to re-license the tracepoint.c/marker.c files from GPL to:
> > 
> > * Dual LGPL v2.1/GPL v2 license.
> > 
> > And re-license tracepoint.h/marker.h to:
> > 
> > * Dual BSD/GPL v2 license.
> > 
> > The goal is to allow sharing code between the kernel tracer and UST
> > (User-Space Tracer) project, which is a LGPL v2.1 library. Tracepoint
> > and marker headers might need to be included by proprietary or BSD
> > applications, hence the dual BSD/GPL v2 license for these two.
> > 
> > I currently have the OK from Kosaki Motohiro for Fujitsu contributions,
> > which includes Zhao Lei and Lai Jiangshan.
> > 
> > The missing approvals for Dual LGPL v2.1/GPL v2 relicensing are:
> > 
> > For tracepoint.c:
> > 
> > Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > 
> > For marker.c:
> > 
> > "Robert P. J. Day" <rpjday@mindspring.com>
> > Adrian Bunk <bunk@stusta.de>
> > Harvey Harrison <harvey.harrison@gmail.com>
> 
> Jesper Juhl <jj@chaosbits.net>
> 

I don't think I have enough significant changes in there to actually 
require my approval for relicensing, but since you ask; I personally 
do not have a problem with that file being Dual LGPL v2.1/GPL v2 
licensed.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

