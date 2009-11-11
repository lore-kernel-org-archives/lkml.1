Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZKKV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZKKV6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759458AbZKKV6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:58:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438AbZKKV6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:58:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ptrace: syscall-exit && stepping fixes
In-Reply-To: Oleg Nesterov's message of  Wednesday, 11 November 2009 22:31:52 +0100 <20091111213152.GA10639@redhat.com>
References: <20091111213152.GA10639@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091111215749.9630FE3@magilla.sf.frob.com>
Date: Wed, 11 Nov 2009 13:57:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least 4-5/5 should be CC'd to the x86 maintainers too.
At least 1/5 should perhaps go to linux-arch to alert other
arch maintainers that implement user_enable_single_step()
to add user_single_step_siginfo() for their arch too.


Thanks,
Roland
