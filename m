Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbXFLOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbXFLOIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXFLOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:08:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:19666 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751332AbXFLOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:08:39 -0400
Subject: Re: [patch 1/4] lockdep: variuos fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: debian developer <debiandev@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <f24d23310706120647n4e125964i3885bd5c340b8903@mail.gmail.com>
References: <20070612121351.448814658@chello.nl>
	 <20070612121916.533503225@chello.nl>
	 <f24d23310706120647n4e125964i3885bd5c340b8903@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 16:08:19 +0200
Message-Id: <1181657299.7348.327.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 19:17 +0530, debian developer wrote:

> On 6/12/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Index: linux-2.6/kernel/lockdep.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/lockdep.c
> > +++ linux-2.6/kernel/lockdep.c
> > @@ -5,7 +5,8 @@
> >   *
> >   * Started by Ingo Molnar:
> >   *
> > - *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> > + *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
> > + *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
> >   *
> >   * this code maps all the lock dependencies as they occur in a live kernel
> >   * and will warn about the following classes of locking bugs:

> What exactly is being copyright'ed here?

Thanks for being triply impolite! You score: anonymous, top-posting and
dropping CC-lists.

The code in these files, as in most other files in the Linux kernel, is
copyrighted. The code is Licensed under GPLv2, but copyright belongs to
Red Hat and it's authors are Ingo and myself.

That is, say you want to use this code in a non GPLv2 project (say this
GPLv3 thing) then you would need to contact the copyright owner of this
code.



