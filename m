Return-Path: <linux-kernel-owner+w=401wt.eu-S1764287AbZFQIfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764287AbZFQIfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZFQIer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:34:47 -0400
Received: from cmpxchg.org ([85.214.51.133]:39999 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764320AbZFQIep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:34:45 -0400
Date: Wed, 17 Jun 2009 10:31:23 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: remove task assumptions from swap token
Message-ID: <20090617083123.GA1879@cmpxchg.org>
References: <Pine.LNX.4.64.0906162152250.12770@sister.anvils> <1245189037-22961-2-git-send-email-hannes@cmpxchg.org> <20090617110034.db01479b.minchan.kim@barrios-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617110034.db01479b.minchan.kim@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:00:34AM +0900, Minchan Kim wrote:
> Hi, Hannes. 
> 
> How about adding Hugh's comment ?

Sorry, I misinterpreted Hugh's reply to me that got into my inbox
directly and totally missed that he had already done the exact same
thing in the lkml thread until much later.

We should probably just use his version.
