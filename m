Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYLENbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYLENbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbYLENbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:31:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46885 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132AbYLENbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:31:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812051321540.10157@blonde.anvils>
References: <Pine.LNX.4.64.0812051321540.10157@blonde.anvils> <20081205091255.26127.91011.stgit@warthog.procyon.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       bfields@fieldses.org, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from fh_to_dentry()/fh_to_parent()
Date: Fri, 05 Dec 2008 13:30:30 +0000
Message-ID: <14769.1228483830@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> This patch looks like it ought to be including mm/shmem.c too?
> Which would you prefer, I send a separate patch, or you update this one?

I've dispatched a new version.

David
