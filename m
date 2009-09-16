Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZIPJmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZIPJmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZIPJmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:42:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33791 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZIPJmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:42:36 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: hwpoison fixes was Re: 2.6.32 -mm merge plans
From: Andi Kleen <andi@firstfloor.org>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
Date: Wed, 16 Sep 2009 11:42:36 +0200
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 15 Sep 2009 16:15:35 -0700")
Message-ID: <87fxancjjn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>
> mm-memory-failure-remove-config_unevictable_lru-config-option.patch
>   -> Andi

Integrated in the patch. Thanks.

>
> hwpoison-fix-uninitialized-warning.patch
>
>   -> Andi

Already added too

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
