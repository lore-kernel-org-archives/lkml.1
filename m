Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYEGUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYEGUM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYEGUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:12:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbYEGUMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:12:44 -0400
Date: Wed, 7 May 2008 13:05:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: clameter@sgi.com, steiner@sgi.com, holt@sgi.com, npiggin@suse.de,
       a.p.zijlstra@chello.nl, kvm-devel@lists.sourceforge.net,
       kanojsarcar@yahoo.com, rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-Id: <20080507130528.adfd154c.akpm@linux-foundation.org>
In-Reply-To: <e20917dcc8284b6a07cf.1210170951@duo.random>
References: <patchbomb.1210170950@duo.random>
	<e20917dcc8284b6a07cf.1210170951@duo.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:35:51 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> # HG changeset patch
> # User Andrea Arcangeli <andrea@qumranet.com>
> # Date 1210096013 -7200
> # Node ID e20917dcc8284b6a07cfcced13dda4cbca850a9c
> # Parent  5026689a3bc323a26d33ad882c34c4c9c9a3ecd8
> mmu-notifier-core

The patch looks OK to me.

The proposal is that we sneak this into 2.6.26.  Are there any
sufficiently-serious objections to this?

The patch will be a no-op for 2.6.26.

This is all rather unusual.  For the record, could we please review the
reasons for wanting to do this?

Thanks.
