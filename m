Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZFPLTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZFPLTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZFPLTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:19:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58714 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbZFPLTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:19:11 -0400
Date: Tue, 16 Jun 2009 13:19:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: remove some includings of blktrace_api.h
Message-ID: <20090616111913.GT11363@kernel.dk>
References: <4A35C547.3090109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A35C547.3090109@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15 2009, Li Zefan wrote:
> When porting blktrace to tracepoints, we changed to trace/block.h
> for trace prober declarations.

Applied

-- 
Jens Axboe

