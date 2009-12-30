Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZL3DKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZL3DKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZL3DKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZL3DKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:10:03 -0500
Date: Tue, 29 Dec 2009 22:09:04 -0500 (EST)
From: caiqian@redhat.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       utrace-devel@redhat.com, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1358829885.2228001262142544881.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1319782550.2227981262142487066.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 0/7] utrace/ptrace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is the new iteration of Roland's utrace patch, this time
> with "rewrite-ptrace-via-utrace" + cleanups in utrace core.

Tested-by: CAI Qian <caiqian@redhat.com>
