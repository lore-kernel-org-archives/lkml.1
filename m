Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZIQUji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZIQUji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZIQUjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:39:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbZIQUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:39:36 -0400
Date: Thu, 17 Sep 2009 13:38:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, menage@google.com,
       bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com
Subject: Re: cgrooups && 2.6.32 -mm merge plans
Message-Id: <20090917133846.a00daece.akpm@linux-foundation.org>
In-Reply-To: <20090917201516.GA29346@redhat.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090917201516.GA29346@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 22:15:16 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 09/15, Andrew Morton wrote:
> >
> > #cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch: Oleg conniptions
> > cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
> > cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
> > cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
> >
> >   Merge after checking with Oleg.
> 
> Well. I think these patches are buggy :/
> 

Well that's never prevented us from merging stuff before.

Thanks, I'll disable the patches for now.  Do we have a grip on what's
wrong and what needs to be done to fix things?
