Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZJ2NkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZJ2NkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZJ2NkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:40:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:34602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZJ2NkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:40:00 -0400
Message-ID: <4AE99B55.2090306@kernel.org>
Date: Thu, 29 Oct 2009 14:40:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Subject: Re: [RFC percpu#for-next] percpu: drop per_cpu__ prefix and add sparse
 annotations, take#2
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This is expanded version of Rusty's drop per_cpu__ prefix patchset
> which first appeared way back and has been bit-rotting waiting for all
> archs to move to the dynamic percpu allocator.  Now that it's
> complete.  I tried to refresh Rusty's patchset and I ended up with
> this rather large patchset.

Patchset landed on percpu#for-next with acked and reviewed-by's added.

Thanks.

-- 
tejun
