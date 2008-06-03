Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYFCWCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYFCWCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYFCWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:02:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYFCWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:02:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: zap_threads: comments && use while_each_thread()
In-Reply-To: Oleg Nesterov's message of  Saturday, 31 May 2008 20:15:37 +0400 <20080531161537.GA5569@tv-sign.ru>
References: <20080531161537.GA5569@tv-sign.ru>
X-Zippy-Says: Has everybody got HALVAH spread all over their ANKLES??...  Now,
    it's time to ``HAVE A NAGEELA''!!
Message-Id: <20080603220151.90E9226FC96@magilla.localdomain>
Date: Tue,  3 Jun 2008 15:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
