Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbXLLU5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbXLLU5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXLLU5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:57:44 -0500
Received: from [198.99.130.12] ([198.99.130.12]:40810 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXLLU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:57:44 -0500
Date: Wed, 12 Dec 2007 15:55:51 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 05/30] blk_end_request: changing um (take 4)
Message-ID: <20071212205551.GC9244@c2.user-mode-linux.org>
References: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 05:42:53PM -0500, Kiyoshi Ueda wrote:
> This patch converts um to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> As a result, the interface of internal function, ubd_end_request(),
> is changed.

Looks OK to me...

		Jeff

-- 
Work email - jdike at linux dot intel dot com
