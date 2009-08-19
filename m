Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZHSC4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZHSC4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZHSC4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:56:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbZHSC4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:56:23 -0400
Date: Tue, 18 Aug 2009 19:54:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Amerigo Wang <amwang@redhat.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.31-rc6
In-Reply-To: <4A8B57AF.9000000@kernel.org>
Message-ID: <alpine.LFD.2.01.0908181954110.3158@localhost.localdomain>
References: <4A84ED76.2050107@kernel.org> <4A8B57AF.9000000@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Aug 2009, Tejun Heo wrote:

> Hello,
> 
> Tejun Heo wrote:
> > Please consider pulling from the following percpu fixes tree.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> 
> Any news about this?  This affects booting on some sparc64 machines.
> If the change is too pervasive at this stage, we can consider
> reverting dynamic percpu allocator conversion for sparc64.

Ok, that just fell between the cracks in my email. Pulled.

		Linus
