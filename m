Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYBKKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYBKKja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYBKKjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:39:19 -0500
Received: from namei.org ([69.55.235.186]:49731 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYBKKjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:39:18 -0500
Date: Mon, 11 Feb 2008 21:38:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/37] Security: Change current->fs[ug]id to current_fs[ug]id()
In-Reply-To: <20080208165224.15902.1262.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0802112137340.27028@us.intercode.com.au>
References: <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
 <20080208165224.15902.1262.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, David Howells wrote:

> Change current->fs[ug]id to current_fs[ug]id() so that fsgid and fsuid can be
> separated from the task_struct.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
