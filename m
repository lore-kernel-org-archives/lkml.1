Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZDQGjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZDQGjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZDQGjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49214 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZDQGjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:01 -0400
Date: Fri, 17 Apr 2009 08:38:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] splice: fix new kernel-doc warnings
Message-ID: <20090417063859.GF4593@kernel.dk>
References: <20090416190955.fb1e07d3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416190955.fb1e07d3.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> splice: fix kernel-doc warnings
> 
> Warning(fs/splice.c:617): bad line: 
> Warning(fs/splice.c:722): No description found for parameter 'sd'
> Warning(fs/splice.c:722): Excess function parameter 'pipe' description in 'splice_from_pipe_begin'

Thanks Randy, applied.

-- 
Jens Axboe

