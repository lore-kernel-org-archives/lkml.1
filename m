Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXGXSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXGXSBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXGXSAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:00:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41564 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbXGXSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:00:51 -0400
Date: Tue, 24 Jul 2007 20:00:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
In-Reply-To: <20070724172217.GA10725@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0707242000120.18990@fbirervta.pbzchgretzou.qr>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com>
 <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org>
 <20070724172217.GA10725@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 25 2007 02:22, Paul Mundt wrote:
>Perhaps CodingStyle can start being versioned, so people can opt out of
>certain 'improvements' whenever someone has a vision, much like some
>nameless licenses.

I'd say Codingstyle is versioned by means of git commit IDs.

>
>Personally I prefer the second style, and if there's a comment block,
>then it makes sense to complete the tree with {}'s (the keyword here is
>prefer, as it's a personal preference). checkpatch has been quite useful
>for catching obviously broken things, and now it seems like it's just
>overreaching. Perhaps this functionality can be split in to a lite
>checkpatch for catching show-stoppers for application and then something
>more akin to a CodingStyle validator for the folks interested in
>arbitrarily defining convention, which they can use freely while the rest
>of us try to get something useful done.

/me thinks of ... checkpath --check-me-harder


	Jan
-- 
