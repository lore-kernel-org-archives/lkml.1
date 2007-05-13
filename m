Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbXEMUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbXEMUGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXEMUGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:06:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38307 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbXEMUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:06:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46476FBF.5010803@s5r6.in-berlin.de>
Date: Sun, 13 May 2007 22:06:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
References: <E1HnHxK-0004CI-00@calista.eckenfels.net> <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> p.s.  before we get into this again where everyone thinks they know
> what they're talking about, i suggest consulting the official
> definitions of those two terms as defined at
> http://www.w3.org/TR/html4/conform.html:
> 
> Deprecated:
> ----------

[...]

> Obsolete:
> --------
> 
> "An obsolete element or attribute is one for which there is no
> guarantee of support by a user agent."

Please quote W3C's entire definition of their notion of obsolete:

"An obsolete element or attribute is one for which there is no guarantee
of support by a user agent. Obsolete elements are no longer defined in
the specification, but are listed for historical purposes in the changes
section of the reference manual."

>   there.  see the difference?  why is this so difficult to grok?
[...]

If you apply W3C's term "obsolete" 1:1 to kernel features, then it would
read:

"An obsolete feature is one for which there is no guarantee of support
by a randomly picked kernel release. Obsolete features are no longer
implemented in this release, but are listed for historical purposes in
Documentation/ABI/removed/."

Except that the term "obsolete" is already used differently in the
context of Linux kernel features; see Documentation/ABI/README.

Also, you say "the official definitions of those terms" were defined at
http://www.w3.org/TR/html4/conform.html.  That's not quite true.  What
you find there are the definitions of those terms as used in the HTML 4
specification.  Nothing more.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
