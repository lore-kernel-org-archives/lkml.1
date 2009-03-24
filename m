Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZCXJdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZCXJdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZCXJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:33:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbZCXJdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:33:09 -0400
Date: Tue, 24 Mar 2009 10:32:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324093245.GA22483@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > posted to the list earlier trying to see if there was anything that
> > could be done to help my specific case.  I've got a system where if
> > someone starts writing out a large file, it kills client NFS writes.
> > Makes the system unusable:
> > http://marc.info/?l=linux-kernel&m=123732127919368&w=2
> 
> I have not had this problem since I applied Arjan's (for some reason
> repeatedly rejected) patch to change the ioprio of the various writeback
> daemons. Under some loads changing to the noop I/O scheduler also seems
> to help (as do most of the non default ones)

(link would be useful)

	Ingo
