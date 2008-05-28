Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYE1USS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYE1USS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYE1USI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:18:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50120 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYE1USH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:18:07 -0400
From: Chris Mason <chris.mason@oracle.com>
To: ksummit-2008-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Date: Wed, 28 May 2008 16:15:55 -0400
User-Agent: KMail/1.9.9
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1211995212.3445.52.camel@localhost.localdomain> <20080528150837.685aa677@bree.surriel.com>
In-Reply-To: <20080528150837.685aa677@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805281615.55386.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Rik van Riel wrote:
> On Wed, 28 May 2008 12:20:12 -0500
>
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > The most obvious solution might be to shut the Janitors project down, or
> > at least more tightly manage its TODO list
>
> I've had some limited success with:
>
> http://kernelnewbies.org/KernelProjects
>
> One problem is that people end up beginning with a project but
> for some reason stop working on it later - with no indication
> as to whether the project ended up being too difficult, or they
> ran out of time, or something else happened...

I think our mistake is the assumption that everyone who wants to contribute to 
the kernel wants to code, or that everyone wants to end up at the top of the 
major feature contributors list.  For lots of people, we're going to be that 
experiment from college they never quite want to admit to later on in life.

Looking at the KernelProjects link, bugzilla is at the buttom and janitors is 
at the top.  I've always thought the janitors project was important, but 
maybe we want to change the emphasis around a bit.

The regressions page on kernelnewbies is out of date, and there are many more 
howtos on coding than on bug hunting.  It doesn't mention linux-next 
anywhere.

I'm not picking on kernelnewbies, it is one of our best resources.  But, going 
back to James' ideas, introducing people to bug hunting is a better way to 
involve them in the community.

Maintainers are easier to interact with when you send good bug reports along 
with a clear way to reproduce it and perhaps a bisection

Getting all of the above is often 95% of the work of fixing it, people are 
most likely to jump into the coding when they've found a bad patch and start 
to wonder if they can fix it themselves.

Along those lines, how about a kernel bug hunting challenge.  The top 
contributor(s) to creating bugzillas that get solved get a new pc, laptop, 
high end graphics card, ssd device...whatever.  We could send the best 
testers hardware that breaks most often...everyone wins.

Other prizes could include tickets to a linux conf of choice (not airline 
tickets, just free entry).

One motivation here is to bring bug reporters from active distro communities 
into testing mainline kernels as well.

-chris
