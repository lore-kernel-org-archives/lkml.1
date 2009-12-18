Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbZLRBRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbZLRBRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZLRBRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:17:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZLRBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:17:21 -0500
Date: Fri, 18 Dec 2009 02:11:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: [PATCH 0/7] utrace/ptrace
Message-ID: <20091218011116.GA29534@redhat.com>
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

This version tries to address some of Peter's comments.

Oleg.

