Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXHOQyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXHOQyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbXHOQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:53:47 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:39378 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203AbXHOQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:53:44 -0400
From: Markus <lists4me@web.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/4] 2.6.23-rc3: known regressions
Date: Wed, 15 Aug 2007 18:53:34 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Jan Dittmer <jdi@l4x.org>,
       Christian Zankel <chris@zankel.net>, linux-alpha@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>
References: <46C09BEA.7010007@googlemail.com>
In-Reply-To: <46C09BEA.7010007@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708151853.35643.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1/3Yz1cffiexIRsJCayaZqzUONScVBIThiJ07M7
	z/zBu6H/YpSTVGaaxQHV2FoD4AEkd8EYq1O3anTNJRc5jcdmFl
	8IZCK6QxI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO 
error: client killed"
> References      : http://lkml.org/lkml/2007/7/22/86
> Last known good : ?
> Submitter       : Markus <lists4me@web.de>
> Caused-By       : ?
> Handled-By      : Ingo Molnar <mingo@elte.hu>
> Status          : problem is being debugged
Last working kernel was the 2.6.22 without cfs. With the patch applied 
it shows the same problem (And so it does with the 2.6.23 as cfs was 
merged). And its caused by the cfs(-patch).

And the real problem is not just restricted to konqueror. Its just 
easier to reproduce. (So the original mails started at 
http://lkml.org/lkml/2007/7/14/60 )

   Markus
