Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYJYOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYJYOgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYJYOgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:36:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59446 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJYOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:36:05 -0400
Date: Sat, 25 Oct 2008 16:37:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: left over things in linux-next after 2.6.28-c1
Message-ID: <20081025143715.GB30900@uranus.ravnborg.org>
References: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> tests
> 
> 	Ananth N Mavinakayanahalli (7):
> 	      Add tests/ directory
> 	      Move locking selftests to tests/
> 	      Move rcutorture to tests/
> 	      Move rtmutex tester to tests/
> 	      Move lkdtm to tests/
> 	      Move kprobes smoke tests to tests/
> 	      Move backtrace selftests to tests/

I have almost given up on this.
Three merge attemps failed for different reasons,
and I will not even have time for my maintainership
duties the next months.

Anyone that can bring it forward?

	Sam

