Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbZKXULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbZKXULu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbZKXULt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbZKXULt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:11:49 -0500
Date: Tue, 24 Nov 2009 21:01:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091124200127.GA5751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is the new iteration of Roland's utrace patch, this time
with "rewrite-ptrace-via-utrace" + cleanups in utrace core.

1-7 are already in -mm tree, I am sending them to simplify the
review.

8-12 don not change the behaviour, simple preparations.

13-14 add utrace-ptrace and utrace

Please review.

Oleg.

