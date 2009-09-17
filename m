Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZIQUvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZIQUvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZIQUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZIQUvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:51:03 -0400
Date: Thu, 17 Sep 2009 22:46:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Roland McGrath <roland@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: tracehooks changes && 2.6.32 -mm merge plans
Message-ID: <20090917204656.GC29346@redhat.com>
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
> #signals-tracehook_notify_jctl-change.patch: needs changelog folding too
> signals-tracehook_notify_jctl-change.patch
> signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
> #signals-introduce-tracehook_finish_jctl-helper.patch: fold into signals-tracehook_notify_jctl-change.patch
> signals-introduce-tracehook_finish_jctl-helper.patch

I think these make sense anyway,

> utrace-core.patch
>
>   utrace.  What's happening with this?

(since Roland didn't reply yet)

I guess this patch should be updated.

Oleg.

