Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXJHSgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXJHSgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXJHSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:36:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXJHSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:36:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470A7847.8070502@s5r6.in-berlin.de>
Date: Mon, 08 Oct 2007 20:34:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net>	<20071008173706.GA12026@uranus.ravnborg.org>	<Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>	<470A708D.4080905@goop.org> <20071008110614.dd671fc7.randy.dunlap@oracle.com>
In-Reply-To: <20071008110614.dd671fc7.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Mon, 08 Oct 2007 11:01:49 -0700 Jeremy Fitzhardinge wrote:
>> Tested-by is more valuable than acked-by, because its empirical. 
>> Acked-by generally means "I don't generally object to the idea of the
>> patch, but may not have read beyond the changelog".  Tested-by implies
>> "I did something that exercised the patch, and it didn't explode" -
>> that's on par with an actual review (ideally all patches would be both
>> tested and reviewed).
> 
> but Tested-by: doesn't have to involve any "actually looking at/reading
> the patch."  Right?
> 
> IOW, the patch could be ugly as sin but it works...

Tested-by translated into German and back into English:  "Works for me,
test methods not specified."

So, putting a Tested-by into the changelog is only useful if the
necessary testing is rather simple (i.e. "fixed the bug which I was
always able to reproduce before") or if the tester is known to have
performed rigorous and sufficiently broad tests.
-- 
Stefan Richter
-=====-=-=== =-=- -=---
http://arcgraph.de/sr/
