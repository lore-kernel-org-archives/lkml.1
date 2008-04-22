Return-Path: <linux-kernel-owner+w=401wt.eu-S1764673AbYDVTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764673AbYDVTAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYDVTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:00:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbYDVTAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:00:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] posix timers: (BUG 10460) discard the pending signal when the timer is destroyed
In-Reply-To: Oleg Nesterov's message of  Tuesday, 22 April 2008 19:38:20 +0400 <20080422153820.GA19900@tv-sign.ru>
References: <20080422153820.GA19900@tv-sign.ru>
X-Zippy-Says: I'm totally DESPONDENT over the LIBYAN situation and the price of CHICKEN..
Message-Id: <20080422185932.24D14270381@magilla.localdomain>
Date: Tue, 22 Apr 2008 11:59:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change looks reasonable to me.


Thanks,
Roland
