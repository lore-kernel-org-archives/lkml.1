Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXLXBA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXLXBA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXLXBAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:00:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXLXBAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:00:15 -0500
Date: Sun, 23 Dec 2007 20:00:03 -0500
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071223200003.4540b4ad@bree.surriel.com>
In-Reply-To: <200712232322.08946.nickpiggin@yahoo.com.au>
References: <20071218211539.250334036@redhat.com>
	<200712212152.19260.nickpiggin@yahoo.com.au>
	<20071221091753.15a18935@bree.surriel.com>
	<200712232322.08946.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 23:22:08 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Not sure how well that translates to real world workloads, but it
> might help somewhere. Admittedly some of the patches are pretty
> complex...

I like your patch series.

They are completely orthogonal to my patches though, so I
won't tie them together by merging your series into mine :)

It looks like the majority of your patches could go into
-mm right away.
