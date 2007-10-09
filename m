Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXJIGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXJIGtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXJIGtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:49:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46750 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXJIGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:48:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470B23F4.7000303@s5r6.in-berlin.de>
Date: Tue, 09 Oct 2007 08:47:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Scott Preece <sepreece@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net> <20071008185225.GK2902@fieldses.org> <7b69d1470710081226w5b6682e6q56bfa2af5ae3f017@mail.gmail.com> <200710082216.28227.rjw@sisk.pl> <20071009020750.GB4504@goodmis.org> <470B1BA9.7080509@s5r6.in-berlin.de> <20071009062757.GA22303@uranus.ravnborg.org> <470B220A.6080102@s5r6.in-berlin.de>
In-Reply-To: <470B220A.6080102@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sam Ravnborg wrote:
>> On Tue, Oct 09, 2007 at 08:11:53AM +0200, Stefan Richter wrote:
>>> The SCM changelog should contain _what_ a patch does and if
>>> necessary _why_ it does so.
>> The _why_ part is more important than _what_. The diff should hopefully
>> explain the _what_ part.
> 
> "What": fix lockup in this and that circumstances
> "Why": because lockups are annoying
> "How": the diff
> (That's what I meant with what and why.)

PS, example with non-trivial why:
What: add ABI which correlates bus cycle counter and local time
Why: apps need it to sync streams from different buses
How: the diff
-- 
Stefan Richter
-=====-=-=== =-=- -=--=
http://arcgraph.de/sr/
