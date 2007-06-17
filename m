Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXFQQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXFQQnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXFQQnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:43:33 -0400
Received: from www.osadl.org ([213.239.205.134]:40151 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753244AbXFQQnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:43:32 -0400
Subject: Re: v2.6.21.4-rt11
From: Thomas Gleixner <tglx@linutronix.de>
To: Nelson Castillo <nelsoneci@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <2accc2ff0706170915h7cc0ce97ofc16bc33f1714567@mail.gmail.com>
References: <20070609210507.GA29194@elte.hu>
	 <2accc2ff0706170915h7cc0ce97ofc16bc33f1714567@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 18:43:25 +0200
Message-Id: <1182098605.8176.422.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 11:15 -0500, Nelson Castillo wrote:
> >      http://rt.wiki.kernel.org
> 
> Not for ARM yet :(
> 
> What should I try for the ARM architecture? 

ARM has a lot of sub architectures and not all of them are supported
yet.

> There are many choices and
> I don't know what is the more friendly. By friendly I mean the one that
> is likely to be merged and that cooperate with you.

Which choices do you mean ?

>   http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt14
> 
> : undefined reference to `usecs_to_cycles'
> make: *** [.tmp_vmlinux1] Error 1

Which ARM sub arch ?

	tglx


