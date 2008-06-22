Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYFVUct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYFVUct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbYFVUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:32:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:45820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbYFVUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:32:24 -0400
Date: Sun, 22 Jun 2008 13:29:50 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in
	get_user_pages() and fix XIP
Message-ID: <20080622202950.GB20800@suse.de>
References: <20080622185327.348377223@mini.kroah.org> <20080622190140.GD20141@suse.de> <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 12:22:47PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 22 Jun 2008, Greg KH wrote:
> >
> > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Let's wait for the vmware breakage report to sort out first.
> 
> 	http://lkml.org/lkml/2008/6/22/10
> 
> before moving it to -stable.

Sure, thanks for pointing that out to me, I'll track it as well.

greg k-h
