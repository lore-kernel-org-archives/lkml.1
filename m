Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZJAQhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZJAQhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZJAQhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:37:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:48934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZJAQhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:37:34 -0400
Message-ID: <4AC4DAAA.7000609@kernel.org>
Date: Fri, 02 Oct 2009 01:36:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001082411.GM14918@kernel.dk>
In-Reply-To: <20091001082411.GM14918@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:37:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Awesome work so far Tejun, I have high hopes for this patchset! I'll
> take some time to review this when I have it, just consider this so far
> a big encouragement to crank away on this. It's always annoyed me that
> we have various methods for doing async work, this promises to unify
> that very nicely.

Ah... thanks.  I've had this in my queue for too long (workqueue
semantics was quite intricate and getting hotplug right took me quite
some time).  It's nice to see it turns out to be not such a bad idea.
:-)

-- 
tejun
