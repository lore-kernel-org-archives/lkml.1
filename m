Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZG3A4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZG3A4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZG3A4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:56:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZG3A4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:56:20 -0400
Message-ID: <4A70EF8D.9000004@redhat.com>
Date: Wed, 29 Jul 2009 20:55:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] tracing, page-allocator: Add trace events for page
 allocation and page freeing
References: <1248901551-7072-1-git-send-email-mel@csn.ul.ie> <1248901551-7072-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1248901551-7072-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> This patch adds trace events for the allocation and freeing of pages,
> including the freeing of pagevecs.  Using the events, it will be known what
> struct page and pfns are being allocated and freed and what the call site
> was in many cases.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
