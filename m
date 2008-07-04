Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYGDAle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYGDAle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 20:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYGDAl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 20:41:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbYGDAlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:41:25 -0400
Date: Thu, 3 Jul 2008 17:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Grant Coady <grant_lkml@dodo.com.au>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc8-mm1--No e100 :( logs say missing formware
Message-Id: <20080703174046.db6647fa.akpm@linux-foundation.org>
In-Reply-To: <29oq64tdu2lqj5pprhk42siri6f3qh4gr2@4ax.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<29oq64tdu2lqj5pprhk42siri6f3qh4gr2@4ax.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2008 09:35:43 +1000 Grant Coady <grant_lkml@dodo.com.au> wrote:

> So where did the firmware go?

Dave ate it.  Please see the thread "[bug?] tg3: Failed to load
firmware "tigon/tg3_tso.bin""

