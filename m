Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXFPM7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXFPM7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXFPM7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:59:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50117 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbXFPM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:59:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4673DE97.6080408@s5r6.in-berlin.de>
Date: Sat, 16 Jun 2007 14:59:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>
Subject: please keep the CodingStyle text in check (was Re: coding style)
References: <20070614184836.GA6520@cvg>	<20070615045111.GU943@1wt.eu>	<46721F18.8090303@intel.com>	<a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>	<Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>	<20070615173206.GA8151@cvg>	<4672D246.2040306@nortel.com>	<20070615110326.b0762b7a.randy.dunlap@oracle.com>	<Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>	<20070615191804.GC8151@cvg> <20070615151026.2a15e622.randy.dunlap@oracle.com>
In-Reply-To: <20070615151026.2a15e622.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 15 Jun 2007 23:18:04 +0400 Cyrill Gorcunov wrote:
>> Actually it would be perfect to get strict rules also for math. and log.
>> operators being splitted on several lines:
> 
> I disagree that CodingStyle should contain such strict rules for
> line continuations.

People seem to forget:

   - CodingStyle is a lot about agreement and existing practice.

   - A longer, bulkier, convoluted, bureaucratic CodingStyle will not
     enhance quality of contributions.
-- 
Stefan Richter
-=====-=-=== -==- =----
http://arcgraph.de/sr/
