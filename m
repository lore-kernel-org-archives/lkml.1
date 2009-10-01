Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZJAIYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZJAIYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZJAIYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:24:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45259 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZJAIYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:24:36 -0400
Date: Thu, 1 Oct 2009 10:24:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001082439.GN14918@kernel.dk>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Tejun Heo wrote:
> I'm attaching test-wq source and Makefile which I used to verify each
> aspect of the new workqueue.  It's pretty easy to write new test
> scenarios using the module so if you're interested in how this
> actually work, it is quite useful.

BTW, you forgot to attach the test-wq source.

-- 
Jens Axboe

