Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbYCGThN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbYCGThN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYCGTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:36:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbYCGTg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:36:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: send_sig_info: don't take tasklist_lock
In-Reply-To: Oleg Nesterov's message of  Friday, 7 March 2008 13:37:20 +0300 <20080307103720.GA9501@tv-sign.ru>
References: <20080307103720.GA9501@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080307193554.24E6427010F@magilla.localdomain>
Date: Fri,  7 Mar 2008 11:35:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a good change to me.

Thanks,
Roland
