Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZADDiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZADDiD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZADDhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:37:52 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:35895 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZADDhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:37:51 -0500
From: Markus Heidelberg <markus.heidelberg@web.de>
Reply-To: markus.heidelberg@web.de
To: Rob Landley <rob@landley.net>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sun, 4 Jan 2009 04:38:13 +0100
User-Agent: KMail/1.9.9
Cc: "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031637k3b571313m934c8881dce1c81@mail.gmail.com> <200901032054.00018.rob@landley.net>
In-Reply-To: <200901032054.00018.rob@landley.net>
Jabber-ID: markus.heidelberg@web.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901040438.14610.markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1+N/XrCf1yCR9Sss/RIJoYf7ZRwMIKc/S3X4jOo
	9eF9ti9x8lyWJ2sYTqnmxmfiy+ADglAlz57NUTustdM+4zUU30
	Tl6giAm/rTlXczLhuufQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley, 04.01.2009:
> On Saturday 03 January 2009 18:37:12 Leon Woestenberg wrote:
> > My argument on thin dependencies indeed mostly holds for run-time
> > dependencies (to reduce size) but also for build dependency (to reduce
> > complexity)*.
> 
> I usually just point to the gnucash 1.6 release as where this sort of thing 
> leads if you ignore it long enough:
> http://lwn.net/2001/0614/
> 
> These days, a more modern example is the way that after even the gentoo folks 
> gave up on trying to build openoffice (and shipped prebuilt binaries of it in 
> their "build everything from source code" OS), Open Office's own developers 
> described that project "profoundly sick" and "stagnating" ( 
> http://developers.slashdot.org/article.pl?sid=08/12/28/0124230 ).

Now that you mention this the second time, I have to ask where you have
this information from. Since I use Gentoo, I was always able to compile
OpenOffice (version 1, 2 and now 3) myself.

At the same time, it was always possible to use prebuilt packages as an
alternative - the same way as it is possible for a few other packages
(Firefox, Thunderbird, Seamonkey, maybe more). But AFAIK compiling from
source is still the preferred method.

Markus

