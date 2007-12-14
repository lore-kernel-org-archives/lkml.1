Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbXLNIEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbXLNIEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:04:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXLNIDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:03:52 -0500
Received: from brick.kernel.dk ([87.55.233.238]:12692 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbXLNIDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:03:52 -0500
Date: Fri, 14 Dec 2007 09:03:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What happened to this patch?  (Re: [BUG] panic after umount (biscted))
Message-ID: <20071214080348.GG19673@kernel.dk>
References: <E1J2yZg-0004aQ-Rn@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J2yZg-0004aQ-Rn@closure.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13 2007, Theodore Ts'o wrote:
> 
> I was going through my set of kernel patches that I've cherry picked on
> LKML for my private kernel, and I noticed this hasn't gotten merged into
> mainline yet.   The original thread was here:
> 
> 	 http://lkml.org/lkml/2007/10/27/61
> 
> and addressed a panic after a umount reported by Sebastian Siewior.  Was
> this addressed in some other way?

Yes, the below wasn't a proposal for inclusion, the problem got fixed
differently by commit 51fd77bd9f512ab6cc9df0733ba1caaab89eb957

-- 
Jens Axboe

