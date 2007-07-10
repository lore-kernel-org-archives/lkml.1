Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXGJH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXGJH5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXGJH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:57:48 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:49430 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbXGJH5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:57:47 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Documentation of kernel messages (Summary)
Date: Tue, 10 Jul 2007 15:59:36 +0800
Message-ID: <989B956029373F45A0B8AF0297081890F05CDE@zch01exm26.fsl.freescale.net>
In-Reply-To: <200707091248.24994.rob@landley.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Documentation of kernel messages (Summary)
Thread-Index: AcfCS3CLZU7IlA2JRTOO3K0GlEWM4gAehNWQ
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Rob Landley" <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kunai, Takashi" <kunai@linux-foundation.jp>, <holzheu@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       <lf_kernel_messages@linux-foundation.org>, <mtk-manpages@gmx.net>,
       <jack@suse.cz>, <randy.dunlap@oracle.com>, <gregkh@suse.de>,
       <pavel@ucw.cz>, <tim.bird@am.sony.com>, <gh@us.ibm.com>,
       <arjan@infradead.org>, <sam@ravnborg.org>, <jengelh@computergmbh.de>,
       <joe@perches.com>, <auke-jan.h.kok@intel.com>, <hansendc@us.ibm.com>,
       <davem@davemloft.net>, <Valdis.Kletnieks@vt.edu>, <kenistoj@us.ibm.com>,
       <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
       <linux-doc@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Rob Landley
> Sent: Tuesday, July 10, 2007 12:48 AM
> To: H. Peter Anvin
> Cc: Kunai, Takashi; holzheu@linux.vnet.ibm.com; Andrew Morton;
> linux-kernel@vger.kernel.org; lf_kernel_messages@linux-foundation.org;
> mtk-manpages@gmx.net; jack@suse.cz; randy.dunlap@oracle.com;
gregkh@suse.de;
> pavel@ucw.cz; tim.bird@am.sony.com; gh@us.ibm.com;
arjan@infradead.org;
> sam@ravnborg.org; jengelh@computergmbh.de; joe@perches.com;
> auke-jan.h.kok@intel.com; hansendc@us.ibm.com; davem@davemloft.net;
> Valdis.Kletnieks@vt.edu; kenistoj@us.ibm.com; schwidefsky@de.ibm.com;
> heiko.carstens@de.ibm.com; linux-doc@vger.kernel.org
> Subject: Re: Documentation of kernel messages (Summary)
> 
> In regard to translating kernel messages:
> 
> On Monday 09 July 2007 01:36:31 H. Peter Anvin wrote:
> > Kunai, Takashi wrote:
> > > (1) Your kernel development proposal will be greatly supported by
> > > Japanese vendor community. At the same time, it needs support from
the
> > > kernel communities, as well.
> >
> > There is a very strong reason for the kernel community to NOT
support
> > this: it makes it much harder to deal with bug reports.
> 
> Agreed.
> 
> There's a proposal in play for translations of documentation, and to
> recruit "language maintainers" (which is an idea I see that Matt
Mackall came
> up with before I did).
> 
> A language maintainer is somebody who can accept a patch in language
X,
> translate its description to post on the appropriate english-only list
with a
> cc: to the appropriate maintainer(s), and translate questions and
reviews
> back and forth for the original author until the patch can be merged.
(This
> means that documentation translations don't result in a stream of
unmergeable
> patches.)
> 
> As for the documentation translations themselves, I note that Eric
Raymond
> dissuaded me from actually hosting translations of kernel
documentation on
> http://kernel.org/doc due to his experience with translations of his
own
> writings.  If he hosts the translations on his website, they never get
> updated again.  But if he makes the contributor host them on their own
> website, then they sometimes get updated.

If the documents are already maintained together on one site, it won't
be very hard to synchronize with kernel.org.  Eric is right for the case
that separate documents on separate sites.

> 
> For my part, I can't _tell_ when a given translation is out of date
because I
> can't read it, and I certainly can't update it.  So I agree with Eric
and I'm
> linking to sites hosting kernel documentation in other languages
rather than
> hosting them myself.  I've got a good link to a Japanese site, need to
ping
> the contributors of the chinese documentation and see if they have a
site for
> it...

Please add a link to http://zh-kernel.org/docs for Chinese translated
kernel documentation.

- Leo
