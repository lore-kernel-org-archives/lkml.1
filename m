Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXEaHlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXEaHlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXEaHlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:41:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbXEaHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:41:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix leakage of -ERESTARTSYS to userland
In-Reply-To: Satoru Takeuchi's message of  Thursday, 31 May 2007 10:55:22 +0900 <87vee9ah9x.wl%takeuchi_satoru@jp.fujitsu.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070531074056.4C4031F8512@magilla.localdomain>
Date: Thu, 31 May 2007 00:40:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That looks good to me.


Thanks,
Roland
