Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXJIJUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXJIJUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 05:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbXJIJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 05:20:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50824 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXJIJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 05:20:05 -0400
Date: Tue, 9 Oct 2007 10:19:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: r/o bind mounts, was Re: -mm merge plans for 2.6.24
Message-ID: <20071009091958.GA17746@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
> r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
> r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
> r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch

<...>

>   Doesn't seem ready yet

I guess we need some more time for this patchset to mature, yes.  But
the four patches I've quoted about are just small preparator cleanups
that should go into 2.6.24.

