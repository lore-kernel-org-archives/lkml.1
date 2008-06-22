Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYFVT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYFVT0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYFVT0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:26:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754AbYFVT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:26:32 -0400
Date: Sun, 22 Jun 2008 12:22:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
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
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages()
 and fix XIP
In-Reply-To: <20080622190140.GD20141@suse.de>
Message-ID: <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
References: <20080622185327.348377223@mini.kroah.org> <20080622190140.GD20141@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jun 2008, Greg KH wrote:
>
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

Let's wait for the vmware breakage report to sort out first.

	http://lkml.org/lkml/2008/6/22/10

before moving it to -stable.

		Linus
