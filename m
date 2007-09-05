Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXIEQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXIEQBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbXIEQBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:01:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10376 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbXIEQBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:01:11 -0400
Date: Wed, 5 Sep 2007 17:56:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
Message-ID: <20070905155638.GC3885@kernel.dk>
References: <20070905152306.3282.70289.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070905152306.3282.70289.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05 2007, David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Make BSG function declarations dependent on CONFIG_BLOCK as they are not
> compilable if the block layer is compiled out.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Thanks David, I did seem to have lost it. Will apply!

-- 
Jens Axboe

