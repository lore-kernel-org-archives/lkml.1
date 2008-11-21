Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYKUI3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYKUI3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYKUI3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:29:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305AbYKUI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:29:07 -0500
Date: Fri, 21 Nov 2008 00:28:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/45] Permit filesystem local caching [ver #41]
Message-Id: <20081121002847.c8fe7aef.akpm@linux-foundation.org>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:41:39 +0000 David Howells <dhowells@redhat.com> wrote:

> These patches add local caching for network filesystems such as NFS and AFS.

For performance reasons, one assumes.  Are there any other reasons?  Disconnected
operation, anything like that?

We would want to know the performance benefits in some detail before even 
looking at the code, no?  Maybe they're in here somewhere but I missed it..
