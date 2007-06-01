Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXFAWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXFAWmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFAWml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:42:41 -0400
Received: from khc.piap.pl ([195.187.100.11]:52897 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXFAWmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:42:40 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Scott Preece <sepreece@gmail.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>
	<alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>
	<m3sl9b5vcm.fsf@maximus.localdomain>
	<7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
	<m3fy5b5nrt.fsf@maximus.localdomain> <46609AEC.4070603@zytor.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 02 Jun 2007 00:42:38 +0200
In-Reply-To: <46609AEC.4070603@zytor.com> (H. Peter Anvin's message of "Fri, 01 Jun 2007 15:17:16 -0700")
Message-ID: <m33b1b5map.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> I think the comment had to do with the concept that ACK/NAK implies
> authority.  If you're not the maintainer, it's rude to imply that you
> are.  Obvious, test reports (good or bad!) are always welcome.

Well, I understand a test is a different thing, an experiment to
see if the patch works or not, while ack/etc. is just opinion
of someone who reads the patch without actually using it.

I think ack/etc doesn't, in any way, imply being the maintainer,
though it imply that the "acker" has actually read the code,
understands it, and believes it's correct (or not, and why).

If we want to differentiate between "authoritative" and
"non-authoritative" opinions (and the name and email address
aren't enough) then I think we need to state that explicite
(perhaps something like "Acked-by: FIRST M. LAST <addr>, XXX
subsystem maintainer" would suffice).
-- 
Krzysztof Halasa
