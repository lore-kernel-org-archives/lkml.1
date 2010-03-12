Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0CLGsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:48:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:49683 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753522Ab0CLGsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:48:41 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/KGDwYcyHKVLyOoEgsG638VGZFH06sAAN+1KBOxv
	Hz9SRIIIAuWX2H
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Avi Kivity <avi@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1268349164-5822-5-git-send-email-acme@infradead.org>
References: <1268349164-5822-1-git-send-email-acme@infradead.org>
	 <1268349164-5822-5-git-send-email-acme@infradead.org>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 07:48:20 +0100
Message-Id: <1268376500.23887.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.70999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 20:12 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 

> In this initial patch it just checks if the output is a tty, if not it falls
> back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
> the previous behaviour is maintaned.
> 
> Pressing enter on a symbol will annotate it, ESC in the annotation window will
> return to the report symbol list.

<build>

Oooooo, major case of happiness.  Nice!

	-Mike

