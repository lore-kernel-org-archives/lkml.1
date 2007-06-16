Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbXFPMlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbXFPMlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbXFPMlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:41:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49852 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbXFPMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:41:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4673DA43.5080109@s5r6.in-berlin.de>
Date: Sat, 16 Jun 2007 14:40:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr> <20070615194140.GE8151@cvg> <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org> <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 13:39, Linus Torvalds wrote:
>> On Fri, 15 Jun 2007, Jan Engelhardt wrote:
>>> Linux maintainers will enforce \t "being"[1] 8, and will also enforce
>>> the 80-column limit[2].
>> Heh. Actually, Linux maintainers have generally very consciously _avoided_ 
>> trying to "enforce" coding style issues.
> 
> Really? "it's not going to be merged unless you turn all uint32_t into
> u_int32_t" is a paraphrased variant of what I was told this month.

Here is a 3rd variant:  I mostly enforce CodingStyle as far as I am
aware of deviations, but because I get so few contributions, I more and
more tend to adjust coding style on my own before commit, rather than to
bother the contributor.
-- 
Stefan Richter
-=====-=-=== -==- =----
http://arcgraph.de/sr/
