Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbXJQCqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbXJQCqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQCqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:46:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1659 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936510AbXJQCqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:46:31 -0400
Subject: Re: [PATCH] [275/2many] MAINTAINERS - KDUMP
From: Joe Perches <joe@perches.com>
To: Simon Horman <horms@verge.net.au>
Cc: vgoyal@in.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       hbabu@us.ibm.com, akpm@linux-foundation.org, ebiederm@xmission.com
In-Reply-To: <20071017021902.GB6709@verge.net.au>
References: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com>
	 <46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com>
	 <20071017021902.GB6709@verge.net.au>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 19:45:34 -0700
Message-Id: <1192589134.9998.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 11:19 +0900, Simon Horman wrote:

> I take it that these changes got shelved or canned,
> as I still don't seem them in Linus' tree.

I have all the changes kept up-to-date.
I still hope to get some variant into a future release.

> But just for the record, the file lists seem
> to be somewhat sort. I'm not sure exactly what the criteria is, but for
> starters, shouldn't all the architecture specific files that only
> contain kexec or kdump code be in there too?

If one of the maintainers, Vivek Goyal or Haren Myneni, cared
to improve the kdump list of files, I'd happily accept it.

My maintainer entry for kdump is:

KDUMP
P:	Vivek Goyal
M:	vgoyal@in.ibm.com
P:	Haren Myneni
M:	hbabu@us.ibm.com
L:	kexec@lists.infradead.org
L:	linux-kernel@vger.kernel.org
W:	http://lse.sourceforge.net/kdump/
S:	Maintained
F:	Documentation/kdump

and if Eric Biederman wants to improve kexec:

KEXEC
P:	Eric Biederman
M:	ebiederm@xmission.com
W:	http://www.xmission.com/~ebiederm/files/kexec/
L:	linux-kernel@vger.kernel.org
L:	kexec@lists.infradead.org
S:	Maintained
F:	include/linux/kexec.h
F:	kernel/kexec.c



