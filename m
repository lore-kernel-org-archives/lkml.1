Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYGWMLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYGWMLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYGWMLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:11:23 -0400
Received: from r00tworld.com ([212.85.137.21]:60893 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYGWMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:11:21 -0400
From: pageexec@freemail.hu
To: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>,
       Greg KH <gregkh@suse.de>
Date: Wed, 23 Jul 2008 13:54:47 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Reply-to: pageexec@freemail.hu
CC: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, greg@kroah.com,
       "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, caglar@pardus.org.tr, casey@schaufler-ca.com,
       spender@grsecurity.net, rodrigo@kernelhacking.com
Message-ID: <48873827.12054.433CA4FB@pageexec.freemail.hu>
In-reply-to: <20080723042737.GC6784@suse.de>
References: <20080701151057.930340322@mini.kroah.org>, <48852E4D.3050405@la.checkpoint.com>, <20080723042737.GC6784@suse.de>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 23 Jul 2008 13:55:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Jul 2008 at 21:27, Greg KH wrote:

> >  2) Disclosure
> >  
> >  The goal of the Linux kernel security team is to work with the
> >  bug submitter to bug resolution as well as disclosure.  We prefer
> > -to fully disclose the bug as soon as possible.  It is reasonable to
> > +to not disclose the bug, since we believe any kind of bug deserves the
> > +same attention and will be quickly patched.  It is reasonable to
> 
> No, again, you are using the word "disclose" in an odd way here.
> 
> Of course the bug is "disclosed" in that it is made public, "here's a
> fix for foo breaking".

it's apparently not true when foo = "kernel's security model", hence the
suggested change to reflect reality.

