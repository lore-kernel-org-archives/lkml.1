Return-Path: <linux-kernel-owner+w=401wt.eu-S1031607AbXEAJPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031607AbXEAJPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031609AbXEAJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:15:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031607AbXEAJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:15:40 -0400
Date: Tue, 1 May 2007 02:15:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: nfsd/md patches Re: 2.6.22 -mm merge plans
Message-Id: <20070501021525.beef1e78.akpm@linux-foundation.org>
In-Reply-To: <20070501090843.GB17949@infradead.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<17974.34116.479061.912980@notabene.brown>
	<20070501090843.GB17949@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 10:08:43 +0100 Christoph Hellwig <hch@infradead.org> wrote:

> apropos nfsd patches, what's the merge plans for my two export ops
> patch series?

box:/usr/src/25/patches> grep -l '^From:.*hch' $(cat-series ../series )
dvb_en_50221-convert-to-kthread-api.patch
simplify-the-stacktrace-code.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
merge-compat_ioctlh-into-compat_ioctlc.patch
cleanup-compat-ioctl-handling.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch

I give up.  Where are they hiding?
