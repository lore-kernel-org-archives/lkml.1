Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYINSkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYINSkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 14:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYINSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 14:39:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYINSj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 14:39:58 -0400
Date: Sun, 14 Sep 2008 20:39:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fmayhar@google.com, adobriyan@gmail.com, roland@redhat.com,
       tglx@linutronix.de
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-ID: <20080914183932.GC28010@elte.hu>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org> <20080914175040.GA819@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914175040.GA819@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> s/mm-commits/lkml/
> 
> (Frank, please don't forget to CC me ;)

Oleg, the changes (with a few fixups from me) are in tip/master now 
(with a rough v2.6.28 target) - should i back them out for now, or do 
you think we can fix the items you noticed gradually?

	Ingo
