Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbXC0L6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbXC0L6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 07:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXC0L6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 07:58:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbXC0L6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 07:58:10 -0400
Subject: Re: [GIT PATCHES] V4L/DVB fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703261454340.6730@woody.linux-foundation.org>
References: <1174881954.4364.5.camel@localhost>
	 <Pine.LNX.4.64.0703261454340.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 27 Mar 2007 08:57:53 -0300
Message-Id: <1174996673.17641.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em Seg, 2007-03-26 às 14:55 -0700, Linus Torvalds escreveu:
> 
> On Mon, 26 Mar 2007, Mauro Carvalho Chehab wrote:
> >
> > Please pull 'master' from:
> >         git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> 
> "Already up-to-date".
> 
> Forgot to push?

Seems so :( I'm too tired those days...

Ok, I've updated from your tree and re-pushed the patches. Please pull
for the following patches:

V4L/DVB (5332): Ir_rc5_timer_end decoder lockup fix
V4L/DVB (5390): Radio: Fix error in Kbuild file
V4L/DVB (5400): Core: fix several locking related problems
V4L/DVB (5408): Fix SECAM handling on saa7115
V4L/DVB (5415): Msp_attach must return 0 if no msp3400 was found.
V4L/DVB (5421): Fix suspend/resume in msp3400 and tuner
V4L/DVB (5441): Saa7146: Fix allocation of clipping memory
V4L/DVB (5472): Isl6421: don't reference freed memory

> 
> 		Linus
-- 
Cheers,
Mauro

