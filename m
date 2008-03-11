Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYCKUa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYCKUa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYCKUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:30:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYCKUaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:30:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] signals: unify send_sigqueue/send_group_sigqueue completely
In-Reply-To: Oleg Nesterov's message of  Tuesday, 11 March 2008 21:11:27 +0300 <20080311181127.GC586@tv-sign.ru>
References: <20080308151025.GA25191@tv-sign.ru>
	<20080311020759.B550126F991@magilla.localdomain>
	<20080311181127.GC586@tv-sign.ru>
X-Zippy-Says: I just had a MAJOR CONTRACT DISPUTE with SUZANNE SOMERS!!
Message-Id: <20080311202940.715CB26F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 13:29:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I don't think we should document the interaction with posix timers, but OK,
> I'll send a small comment update.

I didn't say the documentation has to be misleading about the general
utility of the function.  I said it has to explain the subtlety of the
function's calling convention.


Thanks,
Roland
