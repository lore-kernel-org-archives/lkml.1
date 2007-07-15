Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbXGOTUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbXGOTUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXGOTUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:20:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXGOTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:20:12 -0400
X-Greylist: delayed 3486 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 15:20:12 EDT
Message-ID: <469A717D.1020805@zytor.com>
Date: Sun, 15 Jul 2007 12:11:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Li Yang <leo@zh-kernel.org>, Rob Landley <rob@landley.net>,
       Gerrit Huizenga <gh@us.ibm.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Chinese Language Maintainer
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>	<200707121205.20959.rob@landley.net>	<1184330583.23373.65.camel@Gundam>	<200707131352.12952.rob@landley.net>	<a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com>	<469A6370.4020404@zytor.com> <20070715195008.6bdf48c7@the-village.bc.nu>
In-Reply-To: <20070715195008.6bdf48c7@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> Actually, I disagree.  English *is* the second language learned in
>> school for most European developers (except, obviously, the ones from
>> the British isles), and we don't have that problem.
> 
> Not all those from the British Isles. A first language an English as
> school language is not that uncommon for segments of the population, and
> in Wales schooling may also be such that English is learned as a first
> foreign language.
> 
> That aside, please remember that Europe as a whole is a small place on the
> bigger world stage. The total volume of potential developers in the huge
> and rapidly modernising nations like India and China is vast, and there
> are large highly skilled technical nations that don't teach English to
> everyone technical by default.
> 
> Key documents in other languages is a big help, especially those about
> values, culture and standards because they are things that are not easy
> to understand if your use of English is technically oriented.

No doubt.  My point was merely that the closer to the core of
development, the less translated documents help as the emphasis on
interaction *has* to increase.

In that sense, a translation of "Linux Kernel Internals" and the other
books written on the Linux kernel is more useful.  That doesn't mean, of
course, that there isn't documentation distributed with the kernel that
is intended for users and therefore more useful in translation.
However, I do feel that trying to keep up-to-date translations of design
documentation is at least to some degree a fool's errand, which ends up
having people rely on incomplete and outdated documentation, and cut
them off from the overall community.

	-hpa
