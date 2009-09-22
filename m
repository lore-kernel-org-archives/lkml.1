Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZIVTJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZIVTJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIVTJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:09:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:38646 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751321AbZIVTJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:09:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/YIQRhnIjYAQyAge3Et7/ji3/n45N5GCXYcJZrnz
	+UblYPcU6SHM+c
Subject: Re: mailing list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
In-Reply-To: <4AB8D930.1090308@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <1253620488.13917.29.camel@marge.simson.net>
	 <1253627604.7272.17.camel@marge.simson.net>  <4AB8D930.1090308@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 21:09:16 +0200
Message-Id: <1253646556.7240.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 17:03 +0300, Avi Kivity wrote:
> On 09/22/2009 04:53 PM, Mike Galbraith wrote:
> >
> > Parses fine here, and INSTALL_MOD_STRIP=1 made zero difference.  can you
> > send me that module and .config gzipped up?
> >
> >    
> 
> Sent privately.

I can reproduce with your config, so do don't (thankfully) need to rip
binary apart looking for tools things.  Will take a look.

	Mike

