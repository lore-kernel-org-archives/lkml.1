Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZFAAi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZFAAi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZFAAiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:38:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbZFAAiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:38:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/12 v3] ptrace: introduce task_struct->ptrace_cxt
In-Reply-To: Oleg Nesterov's message of  Sunday, 31 May 2009 00:38:20 +0200 <20090530223820.GA30474@redhat.com>
References: <20090530223820.GA30474@redhat.com>
X-Windows: all the problems and twice the bugs.
Message-Id: <20090601003833.8CB68FC3C7@magilla.sf.frob.com>
Date: Sun, 31 May 2009 17:38:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All looks good to me!

Updated in the rebased-to-current(2.6.30) series at:
	http://userweb.kernel.org/~frob/ptrace-revamp/
or	git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git
	branch ptrace/revamp (rebased branch, not for pulling)


Thanks,
Roland
