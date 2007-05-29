Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbXE2IFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbXE2IFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXE2IFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:05:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXE2IF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:05:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] signal: multithread program returns with wrong errno on
 receiving SIGSTOP
In-Reply-To: Andrew Morton's message of  Tuesday, 29 May 2007 01:03:15 -0700 <20070529010315.d6ed6456.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070529080452.ED8C81F8511@magilla.localdomain>
Date: Tue, 29 May 2007 01:04:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Off hand I think it can happen on all 2.6 kernels in theory.
