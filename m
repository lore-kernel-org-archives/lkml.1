Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZKQG5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZKQG5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZKQG5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:57:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbZKQG5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:57:01 -0500
Date: Tue, 17 Nov 2009 07:56:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf top: Introduce --hide_{user,kernel}_symbols
Message-ID: <20091117065626.GA25865@elte.hu>
References: <1258415125-15019-1-git-send-email-acme@infradead.org>
 <20091117063332.GA8614@elte.hu>
 <1258440295.15006.26.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258440295.15006.26.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2009-11-17 at 07:33 +0100, Ingo Molnar wrote:
> > btw., the user symbol printouts of perf top cause some display problems 
> > - such as below. The DSO printout is way too long to fit into 92 cols, 
> > wrapping around in my terminal and making much of the output unreadable.
> > 
> > Could we cut it by default please?
> 
> An option to turn off userland would be nice too.  If you're 
> interested in the kernel, a display like below is.. suboptimal. 
> (--dso?)

See the subject line :-)

	Ingo
