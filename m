Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbXFPGiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbXFPGiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 02:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXFPGiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 02:38:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:24868 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbXFPGiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 02:38:12 -0400
Date: Sat, 16 Jun 2007 08:38:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
In-Reply-To: <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706160833220.32724@fbirervta.pbzchgretzou.qr>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
 <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
 <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com>
 <20070615110326.b0762b7a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr>
 <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
 <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
 <20070615194140.GE8151@cvg> <Pine.LNX.4.64.0706152210150.32724@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.98.0706151335240.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 13:39, Linus Torvalds wrote:
>On Fri, 15 Jun 2007, Jan Engelhardt wrote:
>> 
>> Linux maintainers will enforce \t "being"[1] 8, and will also enforce
>> the 80-column limit[2].
>
>Heh. Actually, Linux maintainers have generally very consciously _avoided_ 
>trying to "enforce" coding style issues.

Really? "it's not going to be merged unless you turn all uint32_t into
u_int32_t" is a paraphrased variant of what I was told this month.



	Jan
-- 
