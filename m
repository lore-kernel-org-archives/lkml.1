Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIAIGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIAIGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZIAIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:06:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53460 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbZIAIGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:06:38 -0400
Date: Tue, 1 Sep 2009 10:06:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]cfq: fix the log message after dispatched a request
Message-ID: <20090901080640.GR12579@kernel.dk>
References: <4A9CD4C3.9000800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9CD4C3.9000800@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01 2009, Shan Wei wrote:
> The blktrace tools can show process id when cfq dispatched a request,
> using cfq_log_cfqq() instead of cfq_log().

Thanks, queued for 2.6.32.

-- 
Jens Axboe

