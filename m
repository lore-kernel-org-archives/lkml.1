Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbXJJVK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbXJJVK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXJJVKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:10:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbXJJVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:12 -0400
Date: Wed, 10 Oct 2007 17:07:02 -0400
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: Memory controller merge (was Re: -mm merge plans for 2.6.24)
Message-ID: <20071010170702.34fb3eee@cuia.boston.redhat.com>
In-Reply-To: <4701C737.8070906@linux.vnet.ibm.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<4701C737.8070906@linux.vnet.ibm.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 09:51:11 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I was hopeful of getting the bare minimal infrastructure for memory
> control in mainline, so that review is easy and additional changes
> can be well reviewed as well.

I am not yet convinced that the way the memory controller code and
lumpy reclaim have been merged is correct.  I am combing through the
code now and will send in a patch when I figure out if/what is wrong.

I ran into this because I'm trying to merge the split VM code up to
the latest -mm...

-- 
All Rights Reversed
