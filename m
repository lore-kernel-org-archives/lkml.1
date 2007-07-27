Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbXG0BNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbXG0BNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761370AbXG0BNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:13:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63276 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbXG0BNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:13:15 -0400
Date: Thu, 26 Jul 2007 18:17:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Josh Triplett <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
Message-Id: <20070726181710.126d90ff.randy.dunlap@oracle.com>
In-Reply-To: <46A93F92.6050708@s5r6.in-berlin.de>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
	<46A93F92.6050708@s5r6.in-berlin.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 02:42:58 +0200 Stefan Richter wrote:

> Krzysztof Halasa wrote:
> > and even if I could, "always use" seems way too strong in this case.
> 
> Besides, how about reorienting the CodingStyle text to the essential?

I don't mind that.  Send patch(es).

> (But leave the humorous language in --- the few parts that are inherited
> from old versions of that file, now more and more being buried in dry
> nitpicking.)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
