Return-Path: <linux-kernel-owner+w=401wt.eu-S967298AbXFHAbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967298AbXFHAbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967192AbXFHAal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:30:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50880 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967170AbXFHAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:30:38 -0400
Date: Fri, 8 Jun 2007 09:31:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070608093113.4691644b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070607083458.a3fc7737.akpm@linux-foundation.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<20070607214706.3efc5870.kamezawa.hiroyu@jp.fujitsu.com>
	<20070607083458.a3fc7737.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 08:34:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> I assume the above is your code - it's not in the tree?
> 
Ah, that code was disappeared in -mm2. 

But it informed me that I should consider memory unplug v.s. sys_mremap case... 

Thanks, anyway.

-Kame

