Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZEVKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZEVKKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZEVKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:10:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38821 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZEVKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:10:11 -0400
Date: Fri, 22 May 2009 12:16:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] [MCE] Updated 32bit merge for tip x86 mce2 branch
Message-ID: <20090522101619.GD846@one.firstfloor.org>
References: <20090519215631.GA15626@basil.nowhere.org> <4A1660A1.20909@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1660A1.20909@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 05:21:53PM +0900, Hidetoshi Seto wrote:
> > @@ -1,4 +1,4 @@
> > -The following is a list of files and features that are going to be
> > +he following is a list of files and features that are going to be
> >  removed in the kernel source tree.  Every entry should contain what
> >  exactly is going away, why it is happening, and who is going to be doing
> >  the work.  When the feature is removed from the kernel, it should also
> 
> Is it necessary?

I fixed all that and regenerated the tree.

Hopefully the tree can be properly redone now, it's quite messy
that mce2 is still missing all the rc6 mce_64.c changes. I have
to patch around because of this on my followup trees.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
