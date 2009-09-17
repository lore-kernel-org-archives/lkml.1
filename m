Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZIQUUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZIQUUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZIQUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZIQUT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:19:58 -0400
Date: Thu, 17 Sep 2009 22:15:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, bblum@google.com,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: cgrooups && 2.6.32 -mm merge plans
Message-ID: <20090917201516.GA29346@redhat.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Andrew Morton wrote:
>
> #cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch: Oleg conniptions
> cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
> cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
> cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
>
>   Merge after checking with Oleg.

Well. I think these patches are buggy :/

Oleg.

