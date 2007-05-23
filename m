Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXEWB3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXEWB3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 21:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbXEWB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 21:28:56 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:19490 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756841AbXEWB2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 21:28:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 00/69] -stable review
Date: Tue, 22 May 2007 21:28:34 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE807@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 00/69] -stable review
Thread-Index: Aceb94KfUgM+rd3HSLeyFZ52YSsC/gA4VU9g
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521222004.GT6291@stusta.de> <46521BFD.7040703@redhat.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Chuck Ebbert" <cebbert@redhat.com>, "Adrian Bunk" <bunk@stusta.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>, <torvalds@linux-foundation.org>,
       <alan@lxorguk.ukuu.org.uk>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
X-OriginalArrivalTime: 23 May 2007 01:28:34.0882 (UTC) FILETIME=[AE432220:01C79CD9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Chuck Ebbert
> Envoyé : 21 mai 2007 18:24
> 
> Adrian Bunk wrote:
> > On Mon, May 21, 2007 at 12:31:48PM -0700, Andrew Morton wrote:
> >> On Mon, 21 May 2007 12:16:12 -0700
> >> Chris Wright <chrisw@sous-sol.org> wrote:
> >>
> >>> This is the start of the stable review cycle for the 2.6.21.2 release.
> >> Gee a lot of these are fixing recently-added regressions :( ...
> > 
> > If only it would fix all of them...
> > 
> > Michal's list [1] currently contains 51 different regressions in
> > 2.6.21 compared to 2.6.20 (12 of them were already reported before
> > 2.6.21 was released).
> 
> Yeah, 2.6.21 seems awfully buggy, and patches to fix many of 
> the bugs haven't appeared.
> 
> Another 2.6.20 update seems to be in order...

Hi,

If there is a new stable 2.6.20 / 2.6.21, would it be possible that they both contain also this patch to keep the same behaviour between 2.6.20 -> 2.6.22 kernels regarding paravirt_ops GPL export?
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=21564fd2a3deb48200b595332f9ed4c9f311f2a7

Thnx!

- vin
