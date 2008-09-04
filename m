Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYIDHQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYIDHQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYIDHQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:16:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40976 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYIDHQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:16:33 -0400
Date: Thu, 4 Sep 2008 09:16:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-2.6-block#for-2.6.28] block: fix duplicate headers for  /proc/partitions
Message-ID: <20080904071629.GV20055@kernel.dk>
References: <48BECA2D.8000400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BECA2D.8000400@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03 2008, Tejun Heo wrote:
> seqf can be started multiple times for a read and the header should be
> printed only for the initial one.  Fix it.

Applied

-- 
Jens Axboe

