Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYLLLhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYLLLhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYLLLhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:37:04 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18660 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbYLLLhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:37:02 -0500
Date: Fri, 12 Dec 2008 12:36:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block#for-2.6.29] block: simplify and fix empty barrier
Message-ID: <20081212113642.GN23742@kernel.dk>
References: <1227846727-24980-1-git-send-email-tj@kernel.org> <4941D93A.2040405@kernel.org> <20081212063423.GF23742@kernel.dk> <49421088.1050304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49421088.1050304@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Fri, Dec 12 2008, Tejun Heo wrote:
> >> Jens, did you have time to review this?
> > 
> > Sorry yes, I thought I had sent a reply on this already, weird. I
> > committed it last week, and it's tested fine here.
> 
> Ah... thanks.  Next patchset brewing then.  :-)

Excellent. Are you going forward with the explicit peek/dequeue
interface for elv_next_request()? If not, then I'll put some time into
that as I think it needs doing soon. But if you are, I'll happily do
something else instead.

-- 
Jens Axboe

