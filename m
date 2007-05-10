Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXEJTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXEJTbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXEJTbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:31:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbXEJTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:31:36 -0400
Date: Thu, 10 May 2007 12:30:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott Murray <scottm@somanetworks.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH] cpci_hotplug: Convert to use the kthread API
Message-Id: <20070510123046.0def6b9e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705101425400.3671@rancor.yyz.somanetworks.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769657702107-git-send-email-ebiederm@xmission.com>
	<20070422120534.GA20763@infradead.org>
	<Pine.LNX.4.64.0704271802390.3671@rancor.yyz.somanetworks.com>
	<20070504111215.GA3191@infradead.org>
	<Pine.LNX.4.64.0705071412030.3671@rancor.yyz.somanetworks.com>
	<20070509162430.772ae536.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705101425400.3671@rancor.yyz.somanetworks.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 14:29:29 -0400 (EDT) Scott Murray <scottm@somanetworks.com> wrote:

> > or
> > 
> > 	you->kristen->Len->mainline
> >                        |
> >                        v
> >                       -mm
> > 
> > or something else.
> 
> My apologies, it wasn't entirely clear to me that that was happening with 
> the other kthread conversion patches in the big batch, so I didn't follow 
> the normal procedure.  I'll try to stick to the regular flow up the chain
> going forward.

oh that's OK.  I'm kind of a catchall routing service.  It's just that in
this case I wasn't sure which direction the next hop lay in.
