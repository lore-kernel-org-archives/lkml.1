Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbYFHKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbYFHKHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYFHKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:07:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYFHKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:07:37 -0400
Subject: Re: [PATCH -mm 09/25] fix pagecache reclaim referenced bit check
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       mbligh@mbligh.org
In-Reply-To: <20080606210858.32fd6f48@bree.surriel.com>
References: <20080606202838.390050172@redhat.com>
	 <20080606202858.867179392@redhat.com>
	 <20080606180451.31f01e70.akpm@linux-foundation.org>
	 <20080606210858.32fd6f48@bree.surriel.com>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 12:02:06 +0200
Message-Id: <1212919326.19205.99.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 21:08 -0400, Rik van Riel wrote:
> On Fri, 6 Jun 2008 18:04:51 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:

> > Changelog should spell all this out, I guess.
> 
> It's not the Changelog I'm worried about as much as the
> people who are trying to read the code afterwards.

Guess what these people turn to when they look for the rationale of a
change? - the Changelog :-)

