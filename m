Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375Ab0ANTFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0ANTFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109Ab0ANTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:05:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37557 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0ANTFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:05:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B4F6ADC.7090501@s5r6.in-berlin.de>
Date: Thu, 14 Jan 2010 20:05:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] MAINTAINERS: Document new "Q:" patchwork queue
 type
References: <cover.1263452908.git.joe@perches.com>	 <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>	 <4B4F20B3.703@s5r6.in-berlin.de>  <4B4F2402.9040008@s5r6.in-berlin.de>	 <1263490722.1903.12.camel@Joe-Laptop.home>	 <4B4F5CC8.7020107@s5r6.in-berlin.de>	 <1263492789.1903.19.camel@Joe-Laptop.home>	 <4B4F63C4.1040602@s5r6.in-berlin.de> <1263494720.1903.21.camel@Joe-Laptop.home>
In-Reply-To: <1263494720.1903.21.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2010-01-14 at 19:34 +0100, Stefan Richter wrote:
>> MAINTAINERS' MIPS entry links to http://www.linux-mips.org/
>> which in turn points MIPS platform developers to
>> http://patchwork.linux-mips.org/.  So that's already been taken care of.
> 
> www.google.com gives an easy interface to search for links.
> How about we remove all other links in kernel sources?

www.google.com is a rather unreliable tool to obtain patch submission
addresses.  Hence the MAINTAINERS database.  This database is especially
useful to first-timers and to those who submit patches across the tree
or to subsystems with which they normally don't work with.

Patchwork listings OTOH are more interesting to those who work with
particular subsystems on a more regular basis.  Hence there is lesser
need to have the same kind of database for them as for the patch
submission addresses.

Nevertheless, rather exhaustive and always up-to-date listings of
patchwork links already exist at http://patchwork.kernel.org/ and
http://patchwork.ozlabs.org/.  As was pointed out, one or another
subsystem may have a patchwork tracker on another site, but this alone
is not a reason to add and _maintain_ a huge list of patchwork links in
the MAINTAINERS file.

Your proposal to add those links into MAINTAINERS does not duplicate
Google, it duplicates the entry pages of http://patchwork.kernel.org/
and http://patchwork.ozlabs.org/.

And again, the W: entries in MAINTAINERS are an effective way to have
auxiliary information accessible from MAINTAINERS --- indirectly, but
tailored to the needs of each subsystem group, with the possibility to
add arbitrary depth of information, and potentially more up-to-date than
MAINTAINERS.
-- 
Stefan Richter
-=====-==-=- ---= -===-
http://arcgraph.de/sr/
