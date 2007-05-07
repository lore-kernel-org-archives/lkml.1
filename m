Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXEGKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXEGKCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbXEGKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:02:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXEGKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:02:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=t3pTJC9mFElSNnBhgiEaRQTR514lCm46CAM7+v9mGmB8mC/DuP/LtPkDK56zh3Jg1
	WAWjp5q9QagcjAN40cdpA==
Message-ID: <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com>
Date: Mon, 7 May 2007 03:02:02 -0700
From: "Daniel Phillips" <phillips@google.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v9
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Willy Tarreau" <w@1wt.eu>, "Gene Heskett" <gene.heskett@gmail.com>,
       "Mark Lord" <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <20070503140911.GA21916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503140911.GA21916@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I just thought I would mention this, because it is certainly on my
mind.  I can't help
wondering if other folks are also concerned about this.  The thing is,
why don't you
just send your patches to Con who got this whole ball rolling and did a bunch of
great work, proving beyond any reasonable doubt that he is capable of
maintaining
this subsystem, whatever algorithm is finally adopted?  Are you worried that Con
might steal your thunder?  That somehow the scheduler is yours alone?  That you
might be perceived as less of a genius if somebody else gets credit
for their good
work?  NIH?

My perception is that you barged in to take over just when Con got things moving
after the scheduler sat and rotted for several years.  If that is in
any way accurate,
then shame on you.

Regards,

Daniel
