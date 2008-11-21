Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYKUISZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYKUISZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYKUISF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:18:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbYKUISE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:18:04 -0500
Date: Fri, 21 Nov 2008 00:17:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/45] FS-Cache: Provide an add_wait_queue_tail()
 function [ver #41]
Message-Id: <20081121001744.90a45e68.akpm@linux-foundation.org>
In-Reply-To: <20081120144215.10667.81594.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144215.10667.81594.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:42:16 +0000 David Howells <dhowells@redhat.com> wrote:

> Provide an add_wait_queue_tail() function to add a waiter to the back of a
> wait queue instead of the front.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Please update the changelog to explain the reason for this change.
