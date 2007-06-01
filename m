Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXFAFfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXFAFfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXFAFfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:35:10 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59747 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbXFAFfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:35:09 -0400
Date: Fri, 1 Jun 2007 14:34:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparsemem: Shut up unused symbol compiler warnings.
Message-ID: <20070601053404.GA8841@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yasunori Goto <y-goto@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070601042515.GA8628@linux-sh.org> <20070601142124.91F8.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601142124.91F8.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 02:26:17PM +0900, Yasunori Goto wrote:
> I think this issue is fixed by
> move-three-functions-that-are-only-needed-for.patch in current -mm tree.
> Is it not enough?
> 
That's possible, I hadn't checked -mm. This was simply against current
git. If there's already a fix in -mm, then this can simply be ignored.
