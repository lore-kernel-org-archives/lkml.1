Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbXGKL4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbXGKL4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXGKLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:55:56 -0400
Received: from verein.lst.de ([213.95.11.210]:54288 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759AbXGKLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:55:55 -0400
Date: Wed, 11 Jul 2007 13:55:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070711115551.GD18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> mutex_unlock-later-in-seq_lseek.patch
> zs-move-to-the-serial-subsystem.patch
> fs-block_devc-use-list_for_each_entry.patch
>
> introduce-o_cloexec-take-2.patch
> o_cloexec-for-scm_rights.patch
>

Umm, Andrew - mixing new userspace interface, compltely rewritten
drivers and simple fixes in a simple misc category doesn't exactly
help reading this list :)
