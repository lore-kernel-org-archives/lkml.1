Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXFPMbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXFPMbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXFPMbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:31:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49747 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbXFPMbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:31:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4673D7DA.9050309@s5r6.in-berlin.de>
Date: Sat, 16 Jun 2007 14:30:18 +0200
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
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr> <20070615194140.GE8151@cvg> <alpine.LFD.0.98.0706151319430.14121@woody.linux-foundation.org> <Pine.LNX.4.64.0706152228400.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706152228400.32724@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 13:21, Linus Torvalds wrote:
>> On Fri, 15 Jun 2007, Cyrill Gorcunov wrote:
>>> | 
>>> | 	from CodingStyle:
>>> | 	Tabs are 8 characters,
[...]
>> I did indeed write that.
>>
>> Tabs are 8 characters in the kernel coding style.
> 
> That clarification ("in the kernel coding style") should end up in 
> CodingStyle. (Since tabs *are not* just 8 everywhere, which current 
> CodingStyle seems to imply. But maybe I'm just to blunt.)

linux/Documentation/CodingStyle is about... Linux kernel coding style.  :-)
-- 
Stefan Richter
-=====-=-=== -==- =----
http://arcgraph.de/sr/
