Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbZFKQgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbZFKQgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZFKQgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:36:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZFKQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:36:31 -0400
Message-ID: <4A313284.2060409@redhat.com>
Date: Thu, 11 Jun 2009 12:36:20 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] HWPOISON: use the safer invalidate page for possible
 metadata pages
References: <20090611142239.192891591@intel.com> <20090611144430.947740750@intel.com>
In-Reply-To: <20090611144430.947740750@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> As recommended by Nick Piggin.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
