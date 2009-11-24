Return-Path: <linux-kernel-owner+w=401wt.eu-S933433AbZKXQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbZKXQSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbZKXQSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:18:20 -0500
Received: from THUNK.ORG ([69.25.196.29]:46700 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225AbZKXQST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:18:19 -0500
Date: Tue, 24 Nov 2009 11:18:16 -0500
From: tytso@mit.edu
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] ext4: remove encountered_congestion trace
Message-ID: <20091124161816.GN2183@thunk.org>
Mail-Followup-To: tytso@mit.edu, Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20091118082648.140755818@intel.com>
 <20091118082846.404788666@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118082846.404788666@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:26:56PM +0800, Wu Fengguang wrote:
> It is no longer set and scheduled to be removed.
> 
> CC: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks, I've queued it in the ext4 patch queue.

	     	       	      - Ted
