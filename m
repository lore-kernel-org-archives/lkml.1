Return-Path: <linux-kernel-owner+w=401wt.eu-S1946288AbXBIKBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946288AbXBIKBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946289AbXBIKBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:01:13 -0500
Received: from tristate.vision.ee ([194.204.30.144]:34057 "HELO mail.city.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946288AbXBIKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:01:12 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 05:01:11 EST
Message-ID: <45CC44D5.6050602@vision.ee>
Date: Fri, 09 Feb 2007 11:54:29 +0200
From: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@vision.ee>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> sched-add-above-background-load-function.patch
> mm-implement-swap-prefetching.patch
> mm-implement-swap-prefetching-vs-zvc-stuff.patch
> mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
> mm-implement-swap-prefetching-use-ctl_unnumbered.patch
> swap_prefetch-vs-zoned-counters.patch
> add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
> zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
> reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
> sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
> numa-add-zone_to_nid-function-swap_prefetch.patch
> remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
>
>  Hold.
Why hold?

It's been shown this patchset really helps desktop users. Why keep it in -mm
for so long?

L.

