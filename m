Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXFUCxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXFUCxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXFUCxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:53:44 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1930 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXFUCxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:53:43 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <mdpoole@troilus.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 20 Jun 2007 19:53:25 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEDNEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <87ejk6qbco.fsf@graviton.dyn.troilus.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 19:53:57 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 19:53:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I believe compilation copyrights do bear on GPL-licensed software, by
> virtue of the GPL's sentence "[...] rather, the intent is to exercise
> the right to control the distribution of derivative _or collective_
> works based on the Program." (emphasis added).

Ahh, good. So there's no problem with the GPL. I already thought it the most
sensible reading that it included collective works (and it's clear that it
can legally do so), but that makes it clear.

I didn't mean that compilation copyrights have no relevance to GPL issues in
general, just none to the issue of GPLv2 versus GPLv3 and Tivoization. Are
you going to argue that there's a compilation copyright justified by
combining a kernel binary with a signature for that binary? That seems
untenable to me.

> There is a lot of grey and/or arguable area about what constitutes a
> GPL-encumbered collective work versus mere aggregation.

I think it's technically/legally clear what the standards are, but certainly
arguable whether particular works meet that standard. If the choice of works
to combine is sufficiently creative (above and beyond any choices dictated
by functional considerations), it's a GPL-encumbered collective work.

I don't think it's arguable that a signature shipped along with a binary is
a collective work. In any event, if that were true, I think we should be
able to agree that Linus would be required to release his kernel signing
keys.

> Although I
> disagree, I understand and respect that some believe that the kernel
> plus a digital signature over it is "mere aggregation".

It clearly is. What else could it be? The digital signature is a separate
item, a pure number for which there is no copyright interest, that is simply
appended to the kernel. It does not contain significant protected elements
of the kernel. No creative process is used to generate it or attach it. The
decision to append is dictated by purely functional considerations (nobody
creatively picks which signature to bundle with which kernel).

> I would like
> to focus the discussion on that question, though, rather than whether
> the GPL is worded to control the rights to compilations-in-general
> that include GPLed works.

If the kernel plus a digital signature over it is not mere aggregation, then
Linus is violating the GPL by shipping kernel plus digital signatures but
not including the "source code" to produce the signatures. If the
ridiculousness of that is not sufficiently obvious, I'm not sure what else
to say. Where is the outcry that Linus is keeping his signing key secret,
failing to include the source code that he used to build the Linux kernel
distibution?

The past few times this has come up, every possible irrelevent side issue
was raised. For example, that the signature in the case of Linux is not
functional. These considerations do not have anything to do with whether the
combination is mere aggregation or not.

Ironically, this case is even clearer than linking. The two works are quite
literally stapled together. There is no intermingling at all.

DS


