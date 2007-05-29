Return-Path: <linux-kernel-owner+w=401wt.eu-S1763722AbXE2T2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763722AbXE2T2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXE2T2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:28:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXE2T2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:28:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] signal: multithread program returns with wrong errno on receiving SIGSTOP
In-Reply-To: Oleg Nesterov's message of  Tuesday, 29 May 2007 23:22:43 +0400 <20070529192243.GA189@tv-sign.ru>
X-Shopping-List: (1) Mechanical ripping-cat compressors
   (2) Inconvenient companions
   (3) Fragrant minion travesty
   (4) Cryogenic insects
   (5) Characteristic contraception honkers
Message-Id: <20070529192806.0C6101F8511@magilla.localdomain>
Date: Tue, 29 May 2007 12:28:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I knowingly glossed over freezer.  I don't really want to think about
it.  There are more problems than just this with how it goes about it, but
I'd rather leave that alone until it really bites us.


Thanks,
Roland
