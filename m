Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbXG0Hlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbXG0Hlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761046AbXG0Hli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:41:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49761 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbXG0Hlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:41:37 -0400
X-Greylist: delayed 25100 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 03:41:36 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A9A18D.2050401@s5r6.in-berlin.de>
Date: Fri, 27 Jul 2007 09:41:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Josh Triplett <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>	<m3abtir95x.fsf@maximus.localdomain>	<46A93F92.6050708@s5r6.in-berlin.de> <20070726175929.730fc0be.akpm@linux-foundation.org>
In-Reply-To: <20070726175929.730fc0be.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Jul 2007 02:42:58 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Besides, how about reorienting the CodingStyle text to the essential?
...
> If sparse has gone and added a warning for this then it is more than
> nitpicking.  Reducing the amount of noise coming out of sparse is useful.

Sure, that'd be useful.  But then, SubmitChecklist already tells us to
check with sparse before submission.
-- 
Stefan Richter
-=====-=-=== -=== ==-==
http://arcgraph.de/sr/
