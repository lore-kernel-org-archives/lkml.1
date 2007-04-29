Return-Path: <linux-kernel-owner+w=401wt.eu-S1031066AbXD2WaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031066AbXD2WaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031289AbXD2WaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:30:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031066AbXD2W3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LmJaWyavIeIWal4CQRrk4w8hOL16O5sTc4OBK5gEhYZCrIsHJbAFCf2d3n0G6qw5sVitcUiDeSqRfhMRIjo+jnR9jjCQSELDi2dlvgItuyvESbkjQP9WLklecO+Tk858JEcwJ+ASGgN0+6HBnnUvlkXCwbPJUtaFN2pjOJm9V5o=
From: Dennis Brendel <buddabrod@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Mon, 30 Apr 2007 00:29:45 +0200
User-Agent: KMail/1.9.6
Cc: =?utf-8?q?S=2E=C3=87a=C4=9Flar_Onur?= <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <20070428152539.GA21601@elte.hu> <200704291537.34748.caglar@pardus.org.tr> <20070429155828.GA15089@elte.hu>
In-Reply-To: <20070429155828.GA15089@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704300029.46371.buddabrod@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007, Ingo Molnar wrote:
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> > I'll report if i can find any reproducable problem, so far CFSv7 works
> > as expected :)
>
> ok :)
>
> 	Ingo

One small regression: I worked for hours with cfs v7 as scheduler while  
listening to music (with amarok/xine engine) and the music stuttered 3 times 
in 5 hours. After then i watched a movie and that stuttered 2 times, too. But 
when i watched that previously stuttering scenes again, there was no 
stuttering.

It's not directly reproducable, it happens randomly.
