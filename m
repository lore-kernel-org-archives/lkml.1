Return-Path: <linux-kernel-owner+w=401wt.eu-S1765585AbZAOXeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765585AbZAOXeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbZAOXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:33:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:35770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765437AbZAOXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:33:20 -0500
Subject: Re: [GIT PULL] scheduler fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1232061471.8870.77.camel@laptop>
References: <20090115220809.GA7793@elte.hu>
	 <1232061471.8870.77.camel@laptop>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 00:33:11 +0100
Message-Id: <1232062391.8870.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In specific, these two:

> >       sched: SCHED_IDLE weight change
> >       sched: SCHED_OTHER vs SCHED_IDLE isolation

Ought to have:

  From: Mike Galbraith <efault@gmx.de>

Linus could you fix that up or tell Ingo to fix it up for you? :-)

---

Dear lazyweb,

Could somebody please 'fix' quilt to not eat From thingies in patches
but put them in the body of the generated email?



