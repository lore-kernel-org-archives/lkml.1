Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZHQHzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZHQHzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZHQHzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:55:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZHQHzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:55:36 -0400
Date: Mon, 17 Aug 2009 09:55:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] lock_dep: Fix missing entry in /proc/lock_stat
Message-ID: <20090817075518.GA15390@elte.hu>
References: <4A88ED15.20800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A88ED15.20800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nice fixes and cleanups - i've applied them to tip:core/locking.

Thanks,

	Ingo
