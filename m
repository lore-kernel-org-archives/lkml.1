Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0CDX3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:29:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669Ab0CDX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:29:09 -0500
Date: Thu, 4 Mar 2010 15:29:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Fix some coding styles on mm/ tree
Message-Id: <20100304152904.c2d26745.akpm@linux-foundation.org>
In-Reply-To: <20100304110916.GA3197@localhost.localdomain>
References: <20100304110916.GA3197@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 19:09:16 +0800
wzt.wzt@gmail.com wrote:

> Fix some coding styles on mm/ tree.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> ---
>  mm/filemap.c     |   10 ++++------
>  mm/filemap_xip.c |    3 +--
>  mm/slab.c        |    8 ++++----
>  mm/vmscan.c      |    4 ++--
>  4 files changed, 11 insertions(+), 14 deletions(-)

I don't mind fixing coding-style issues in there, but I would prefer
that it be more comprehensive than this - someone sits down and does a
series of large, more complete subystem-wide cleanups then sure, in the
long term it's worth the pain of merging them.

But I don't think it's good to do this as a slow, random ad-hoc
pitter-patter of changes like this one.

