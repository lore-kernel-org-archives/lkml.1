Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbYB1UVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbYB1UVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYB1UVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:21:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYB1UVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:21:00 -0500
Date: Thu, 28 Feb 2008 15:20:44 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [patch 04/21] free swap space on swap-in/activation
Message-ID: <20080228152044.218efa45@bree.surriel.com>
In-Reply-To: <1204229154.5301.22.camel@localhost>
References: <20080228192908.126720629@redhat.com>
	<20080228192928.251195952@redhat.com>
	<1204229154.5301.22.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:05:53 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Thu, 2008-02-28 at 14:29 -0500, Rik van Riel wrote:
> > plain text document attachment (rvr-00-linux-2.6-swapfree.patch)
> > + lts' convert anon_vma list lock to reader/write lock patch
> > + Nick Piggin's move and rework isolate_lru_page() patch
> 
> Hi, Rik:
> 
> We no long depend on the anon_vma rwlock patch, right?   And, since
> they're now all part of the same series, we can probably loose the note
> about depending on Nick's move/rework patch.  These are hold overs from
> my overly paranoid dependency annotations.  We can fix the description
> on next posting.  [Or am I being too pessimistic?]

Fixed the description for the next posting.  Thanks.

-- 
All rights reversed.
