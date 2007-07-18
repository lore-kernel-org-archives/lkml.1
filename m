Return-Path: <linux-kernel-owner+w=401wt.eu-S1765826AbXGRC2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765826AbXGRC2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 22:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXGRC23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 22:28:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbXGRC23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 22:28:29 -0400
Date: Tue, 17 Jul 2007 19:27:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Breeds <tony@bakeyournoodle.com>
cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 2.6.22-git ppc build failure
In-Reply-To: <20070718022433.GY10345@bakeyournoodle.com>
Message-ID: <alpine.LFD.0.999.0707171927110.27353@woody.linux-foundation.org>
References: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com>
 <20070718010355.GV10345@bakeyournoodle.com>
 <alpine.LFD.0.999.0707171843370.27353@woody.linux-foundation.org>
 <20070718022433.GY10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Tony Breeds wrote:
>
> On Tue, Jul 17, 2007 at 06:44:26PM -0700, Linus Torvalds wrote:
> 
> > Thanks. I assume this has been boot-tested too, and everything else from 
> > the PCI merge was ok?
> 
> *cough* umm the boot test fails.  I'll look harder at the merge, and
> provide a better patch.

Ok, thanks. Maybe it's the merge, and maybe it's one of the sides. You 
might want to double-check that both parents are ok before you look too 
closely at the merge itself.

		Linus
