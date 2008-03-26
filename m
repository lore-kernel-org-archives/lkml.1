Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbYCZPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbYCZPe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYCZPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:34:07 -0400
Received: from waste.org ([66.93.16.53]:59413 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbYCZPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:34:05 -0400
Subject: Re: [PATCH] smaps: account swap entries
From: Matt Mackall <mpm@selenic.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1206545304.8514.494.camel@twins>
References: <1206545304.8514.494.camel@twins>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:32:43 -0500
Message-Id: <1206545563.3527.79.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 16:28 +0100, Peter Zijlstra wrote:
> Subject: smaps: account swap entries
> 
> Show the amount of swap for each vma. This can be used to see where all the
> swap goes.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks great to me.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

