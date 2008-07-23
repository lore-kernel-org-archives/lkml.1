Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYGWO5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYGWO5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYGWO5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:57:21 -0400
Received: from r00tworld.com ([212.85.137.21]:39913 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYGWO5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:57:20 -0400
From: pageexec@freemail.hu
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Wed, 23 Jul 2008 16:53:21 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Reply-to: pageexec@freemail.hu
CC: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@la.checkpoint.com>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
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
Message-ID: <48876201.10516.43E02072@pageexec.freemail.hu>
In-reply-to: <20080723143125.GB4684@khazad-dum.debian.net>
References: <20080723042737.GC6784@suse.de>, <48873827.12054.433CA4FB@pageexec.freemail.hu>, <20080723143125.GB4684@khazad-dum.debian.net>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 23 Jul 2008 16:54:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Jul 2008 at 11:31, Henrique de Moraes Holschuh wrote:

> On Wed, 23 Jul 2008, pageexec@freemail.hu wrote:
> > it's apparently not true when foo = "kernel's security model", hence the
> > suggested change to reflect reality.
> 
> I heavily suggest using something else than "disclose".  
> 
> For the security community, "disclose" doesn't mean you have the source code
> for the buggy code and the source code for the fix.  It means you have the
> information that it is a "foo = kernel's security model" bug, and a
> description of the consequences of the bug for foo (the security model).
> 
> This is NOT what "disclose" means for the Linux kernel, right now.  Here,
> "disclose" means "you know there is a bug, you have the code, you have the
> bug fix".  But you don't know that "foo = kernel's security bug", or the
> consequences of the bug for the security model.

i think you misunderstood the whole thread here ;). we were explicitly
talking about bugs where the kernel devs *knew* they were fixing one
with an impact on security yet they chose not to say so.

determining whether a bug is a security one is a whole different kettle
of fish, that was not the topic here at all.

IOW, Documentation/SecurityBugs talks about bugs where the security impact
is known, not about bugs in general where such determination has yet to be
done.

> So just use another word, or properly qualify WHAT is going to be disclosed,
> (and in this case, WHAT is not going to be *usually* disclosed).


