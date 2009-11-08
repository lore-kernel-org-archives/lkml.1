Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZKHKw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZKHKw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZKHKwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:52:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZKHKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:52:24 -0500
Date: Sun, 8 Nov 2009 11:51:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] sched: fix bug that task run on a wrong and
 unallowed cpu
Message-ID: <20091108105145.GC11372@elte.hu>
References: <4AF39B6D.50001@cn.fujitsu.com>
 <1257481838.6394.56.camel@marge.simson.net>
 <1257481953.6394.57.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257481953.6394.57.camel@marge.simson.net>
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

> btw, I missed the fact that you were seeing this in latest tip,
> otherwise I'd have warned you :)

should be all fixed now - let me know if there's still any problems.

	Ingo
