Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXJIGNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXJIGNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXJIGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:13:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45676 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXJIGNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:13:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470B1BA9.7080509@s5r6.in-berlin.de>
Date: Tue, 09 Oct 2007 08:11:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Scott Preece <sepreece@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net> <20071008185225.GK2902@fieldses.org> <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com> <200710082216.28227.rjw@sisk.pl> <20071009020750.GB4504@goodmis.org>
In-Reply-To: <20071009020750.GB4504@goodmis.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> But for those that run test suites, they should be smart enough to put
> in more documentation into the change log to state how it was tested.

I disagree.  The SCM changelog should contain _what_ a patch does and if
necessary _why_ it does so.  The rest (e.g. the sign-off tag to state
that the licensing is alright, and any other tags) should have its
meaning sufficiently defined outside the changelog.

Remember what the SCM changelog is for, i.e. what we do with it after
commit.
-- 
Stefan Richter
-=====-=-=== =-=- -=--=
http://arcgraph.de/sr/
