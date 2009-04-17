Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZDQHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZDQHOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZDQHOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:14:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51163 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZDQHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:14:09 -0400
Date: Fri, 17 Apr 2009 09:14:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: use BIO list management functions
Message-ID: <20090417071408.GJ4593@kernel.dk>
References: <20090417063217.GA3515@localhost.localdomain> <20090417063702.GA16744@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417063702.GA16744@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, Christoph Hellwig wrote:
> On Fri, Apr 17, 2009 at 03:32:17PM +0900, Akinobu Mita wrote:
> > Impact: cleanup
> 
> I though we had pretty broad agreement that these lines are utter crap?
> :)

Agree on that...

-- 
Jens Axboe

