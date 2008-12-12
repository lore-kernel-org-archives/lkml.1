Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYLLHTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYLLHTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYLLHTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:19:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:38331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYLLHTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:19:02 -0500
Message-ID: <49421088.1050304@kernel.org>
Date: Fri, 12 Dec 2008 16:19:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block#for-2.6.29] block: simplify and fix empty barrier
References: <1227846727-24980-1-git-send-email-tj@kernel.org> <4941D93A.2040405@kernel.org> <20081212063423.GF23742@kernel.dk>
In-Reply-To: <20081212063423.GF23742@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Dec 2008 07:18:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Dec 12 2008, Tejun Heo wrote:
>> Jens, did you have time to review this?
> 
> Sorry yes, I thought I had sent a reply on this already, weird. I
> committed it last week, and it's tested fine here.

Ah... thanks.  Next patchset brewing then.  :-)

-- 
tejun
