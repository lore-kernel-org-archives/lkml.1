Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYGJQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYGJQfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYGJQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:35:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55283 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYGJQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:35:33 -0400
Date: Thu, 10 Jul 2008 12:35:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: UML kernel failed to start betvee 2.6.8-rc8 and current git
	sources
Message-ID: <20080710163514.GA17561@c2.user-mode-linux.org>
References: <200807101619.54052.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807101619.54052.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 04:19:51PM +0200, Toralf Förster wrote:
> from v2.6.26-rc8 to v2.6.26-rc9-56-g6329d30 sth. affected UML, b/c my user mode linux kernel produces this :
> 
> ...
> VFS: Mounted root (ext3 filesystem) readonly.
> Registers -
>         0       0x0
>         1       0x0
>         2       0x0
>         3       0x0
>         4       0x0
>         5       0x0
>         6       0x0
>         7       0x0
>         8       0x0
>         9       0x0
>         10      0x0
>         11      0x0
>         12      0x0
>         13      0x0
>         14      0x0
>         15      0x0
>         16      0x0
> Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, errno = 5
> 

I have 2.6.26-rc9-00010-g3bc5ab9 and it seems fine.  I'll pull the latest git
and see if that's still OK.

What's the host?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
