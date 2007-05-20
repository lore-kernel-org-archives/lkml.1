Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbXETBKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbXETBKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 21:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXETBJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 21:09:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46749 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbXETBJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 21:09:54 -0400
Date: Sun, 20 May 2007 03:10:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Bob Tracy <rct@gherkin.frus.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Christian Volkmann <haveaniceday@cv-sv.de>,
       linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [1/2] 2.6.22-rc2: known regressions with patches
Message-ID: <20070520011050.GA31667@uranus.ravnborg.org>
References: <464F74F2.8090207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F74F2.8090207@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 12:06:42AM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc2
> with patches available.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> Unclassified
> 
> Subject    : 2.6.22-rc2: section mismatch
> References : http://lkml.org/lkml/2007/5/19/59
> Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
> Handled-By : Sam Ravnborg <sam@ravnborg.org>
> Status     : fixed in kbuild-git.git
2 warnings are fixed in kbuild.git
The rest are fixed by http://lkml.org/lkml/2007/5/19/89 which I assume Andi Keen
take care of.

	Sam
