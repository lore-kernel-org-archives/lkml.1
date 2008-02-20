Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYBTIFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYBTIFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYBTIFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:05:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:29539 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYBTIFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:05:35 -0500
Date: Wed, 20 Feb 2008 09:05:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix kernel-docbook parameters and files
Message-ID: <20080220080531.GO23197@kernel.dk>
References: <20080218130445.f5f5a205.randy.dunlap@oracle.com> <20080219204725.GM23197@kernel.dk> <20080219131847.24f4659a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219131847.24f4659a.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> kernel-doc for block/:
> - add missing parameters
> - fix one function's parameter list (remove blank line)
> - add 2 source files to docbook for non-exported kernel-doc functions

Thanks Randy, applied.

-- 
Jens Axboe

