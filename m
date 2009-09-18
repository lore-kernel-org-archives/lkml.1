Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZIRRw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZIRRw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbZIRRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:52:55 -0400
Received: from THUNK.ORG ([69.25.196.29]:33115 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbZIRRwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:52:54 -0400
Date: Fri, 18 Sep 2009 13:52:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090918175252.GF26991@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"jack@suse.cz" <jack@suse.cz>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com> <20090911134241.GB19707@mit.edu> <20090911141659.GA3508@infradead.org> <20090911142926.GI14984@kernel.dk> <20090911143929.GA25499@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911143929.GA25499@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 10:39:29PM +0800, Wu Fengguang wrote:
> 
> That would be good. Sorry for the late work. I'll allocate some time
> in mid next week to help review and benchmark recent writeback works,
> and hope to get things done in this merge window.

Did you have some chance to get more work done on the your writeback
patches?

Thanks,

					- Ted
