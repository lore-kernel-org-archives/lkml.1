Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYHGLIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYHGLIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 07:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHGI5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:57:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:56578 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbYHGI5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:57:22 -0400
Date: Thu, 7 Aug 2008 18:50:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, morgan@kernel.org, sfr@canb.auug.org.au,
       viro@ftp.linux.org.uk, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/24] Introduce credentials [ver #7]
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808071843550.18106@tundra.namei.org>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, David Howells wrote:

> 
> 
> I've brought my patchset up to date with regards the recent merge melee and
> built the patches on top of the next branch of James's security testing tree as
> per his request.

These patches don't apply from here on:

Applying CRED: Detach the credentials from task_struct [ver #7]
error: patch failed: include/linux/cred.h:158
error: include/linux/cred.h: patch does not apply
error: patch failed: include/linux/init_task.h:115
error: include/linux/init_task.h: patch does not apply
error: patch failed: include/linux/sched.h:1109
error: include/linux/sched.h: patch does not apply
error: patch failed: kernel/fork.c:145
error: kernel/fork.c: patch does not apply
error: patch failed: security/selinux/hooks.c:166
error: security/selinux/hooks.c: patch does not apply
error: patch failed: security/smack/smack_lsm.c:984
error: security/smack/smack_lsm.c: patch does not apply
Patch failed at 0008.



- James
-- 
James Morris
<jmorris@namei.org>
