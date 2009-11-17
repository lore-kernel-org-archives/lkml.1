Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZKQH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZKQH0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZKQH0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:26:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:57131 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754567AbZKQH0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:26:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+pV2xE9p6p/3aU6Pe2ipMspMyky6UjCqz/KQTgC1
	kp/AH3pC2GxLXC
Subject: Re: [PATCH 1/2] perf top: Introduce --hide_{user,kernel}_symbols
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20091117065626.GA25865@elte.hu>
References: <1258415125-15019-1-git-send-email-acme@infradead.org>
	 <20091117063332.GA8614@elte.hu>
	 <1258440295.15006.26.camel@marge.simson.net>
	 <20091117065626.GA25865@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Nov 2009 08:26:18 +0100
Message-Id: <1258442778.16995.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 07:56 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2009-11-17 at 07:33 +0100, Ingo Molnar wrote:
> > > btw., the user symbol printouts of perf top cause some display problems 
> > > - such as below. The DSO printout is way too long to fit into 92 cols, 
> > > wrapping around in my terminal and making much of the output unreadable.
> > > 
> > > Could we cut it by default please?
> > 
> > An option to turn off userland would be nice too.  If you're 
> > interested in the kernel, a display like below is.. suboptimal. 
> > (--dso?)
> 
> See the subject line :-)

Heh.  I read the text as cut the width only.  $subject works for me :)

	-Mike

