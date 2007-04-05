Return-Path: <linux-kernel-owner+w=401wt.eu-S1767453AbXDEXzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767453AbXDEXzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767454AbXDEXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:55:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57885 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767453AbXDEXzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:55:41 -0400
Date: Thu, 5 Apr 2007 16:55:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
Message-Id: <20070405165538.d704d642.akpm@linux-foundation.org>
In-Reply-To: <46158793.9010608@vmware.com>
References: <46158674.5090709@vmware.com>
	<46158793.9010608@vmware.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 16:34:43 -0700
Zachary Amsden <zach@vmware.com> wrote:

> > I noticed this never got applied.  There was some feedback which I did 
> > not include in this patch because I think it is inappropriate to touch 
> > code outside vmi.c at this point for 2.6.21.  Please apply; this patch 
> > is needed as a bugfix in 2.6.21.  An updated version for 2.6.22 will 
> > come later which has a nicer interface.
> >

There was a big foodfight last time you sent this out and I'd assumed that
there were still unresolved issues.  Or at least a general auru of
unhappiness.

I guess we merge it now, then (forget to) fix up those issues later on.

> Erm, stale patch, sorry.  This one instead.

yeah, that's the patch which has been in -mm for a week.
