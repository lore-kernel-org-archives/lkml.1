Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbZKXQSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbZKXQSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933448AbZKXQSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:18:35 -0500
Received: from THUNK.ORG ([69.25.196.29]:46708 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbZKXQSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:18:34 -0500
Date: Tue, 24 Nov 2009 11:18:29 -0500
From: tytso@mit.edu
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/12] ext4: remove unused parameter wbc from
 __ext4_journalled_writepage()
Message-ID: <20091124161829.GO2183@thunk.org>
Mail-Followup-To: tytso@mit.edu, Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20091118082648.140755818@intel.com>
 <20091118082846.530386547@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118082846.530386547@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:26:57PM +0800, Wu Fengguang wrote:
> CC: Theodore Ts'o <tytso@mit.edu> 
> CC: Jan Kara <jack@suse.cz> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks, I've queued it in the ext4 patch queue.

	     	       	      	   	 - Ted
