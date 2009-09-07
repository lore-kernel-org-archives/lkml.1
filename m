Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZIGQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZIGQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZIGQ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:28:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZIGQ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:28:39 -0400
Message-ID: <4AA5367E.6010103@redhat.com>
Date: Mon, 07 Sep 2009 19:36:14 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/3] ksm: clean up obsolete references
References: <Pine.LNX.4.64.0909052219580.7381@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909052219580.7381@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> A few cleanups, given the munlock fix: the comment on ksm_test_exit()
> no longer applies, and it can be made private to ksm.c; there's no
> more reference to mmu_gather or tlb.h, and mmap.c doesn't need ksm.h.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>   
Acked-by: Izik Eidus <ieidus@redhat.com>

