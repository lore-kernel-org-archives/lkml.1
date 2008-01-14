Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYANVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYANVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYANVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:22:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYANVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:22:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix the "remove task_ppid_nr_ns" commit
In-Reply-To: Oleg Nesterov's message of  Tuesday, 15 January 2008 00:02:37 +0300 <20080114210237.GA2244@tv-sign.ru>
References: <20080114210237.GA2244@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080114212214.78DF826FA0B@magilla.localdomain>
Date: Mon, 14 Jan 2008 13:22:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This preserves the parts of my change that mattered, is correctly more
conservative than my change was, and is fine with me.

Thanks,
Roland
