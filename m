Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab0CKWPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:15:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:51164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab0CKWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:15:37 -0500
Date: Thu, 11 Mar 2010 19:15:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 6/6] perf report: Initial TUI using newt
Message-ID: <20100311221529.GM14180@ghostprotocols.net>
References: <1268345617-31863-1-git-send-email-acme@infradead.org> <1268345617-31863-6-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268345617-31863-6-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 11, 2010 at 07:13:37PM -0300, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Newt has widespread availability and provides a rather simple API as can be
> seen by the size of this patch.
> 
> The work needed to support it will benefit other frontends too.
> 
> In this initial patch it just checks if the output is a tty, if not it falls
> back to the previous behaviour, also if newt-devel/libnewt-dev is not installed
> the previous behaviour is maintaned.

Argh, please don't consider this last patch (6/6), I messed up, will
repost just this one in a few moments.

- Arnaldo
