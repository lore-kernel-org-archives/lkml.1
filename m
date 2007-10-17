Return-Path: <linux-kernel-owner+w=401wt.eu-S936588AbXJQDtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936588AbXJQDtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936331AbXJQDsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:48:46 -0400
Received: from koto.vergenet.net ([210.128.90.7]:47280 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbXJQDsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:48:46 -0400
Date: Wed, 17 Oct 2007 12:48:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       vgoyal@in.ibm.com, ebiederm@xmission.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [275/2many] MAINTAINERS - KDUMP
Message-ID: <20071017034840.GA28414@verge.net.au>
References: <46bffa99.nQ27DQOgkKo2uOy+%joe@perches.com> <46bffa8e.NHuk7h7puR+3eDXo%joe@perches.com> <20071017021902.GB6709@verge.net.au> <1192589134.9998.93.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192589134.9998.93.camel@localhost>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 07:45:34PM -0700, Joe Perches wrote:
> On Wed, 2007-10-17 at 11:19 +0900, Simon Horman wrote:
> 
> > I take it that these changes got shelved or canned,
> > as I still don't seem them in Linus' tree.
> 
> I have all the changes kept up-to-date.
> I still hope to get some variant into a future release.
> 
> > But just for the record, the file lists seem
> > to be somewhat sort. I'm not sure exactly what the criteria is, but for
> > starters, shouldn't all the architecture specific files that only
> > contain kexec or kdump code be in there too?
> 
> If one of the maintainers, Vivek Goyal or Haren Myneni, cared
> to improve the kdump list of files, I'd happily accept it.

Understood. I'm happy to make a start on that.
Do you have a criteria for including files.
Are they files that only apply to KEXEC/KDUMP,
or files that have KEXEC/KDUMP code and other code?

> My maintainer entry for kdump is:
> 
> KDUMP
> P:	Vivek Goyal
> M:	vgoyal@in.ibm.com
> P:	Haren Myneni
> M:	hbabu@us.ibm.com
> L:	kexec@lists.infradead.org
> L:	linux-kernel@vger.kernel.org
> W:	http://lse.sourceforge.net/kdump/
> S:	Maintained
> F:	Documentation/kdump
> 
> and if Eric Biederman wants to improve kexec:
> 
> KEXEC
> P:	Eric Biederman
> M:	ebiederm@xmission.com
> W:	http://www.xmission.com/~ebiederm/files/kexec/
> L:	linux-kernel@vger.kernel.org
> L:	kexec@lists.infradead.org
> S:	Maintained
> F:	include/linux/kexec.h
> F:	kernel/kexec.c
> 
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

