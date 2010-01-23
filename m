Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463Ab0AWHVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0AWHVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 02:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702Ab0AWHVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 02:21:13 -0500
Received: from snt0-omc4-s12.snt0.hotmail.com ([65.55.90.215]:28484 "EHLO
	snt0-omc4-s12.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab0AWHVM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 02:21:12 -0500
Message-ID: <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <venkatesh.pallipadi@intel.com>, <markh@compro.net>
CC: <dmarkh@cfl.rr.com>, <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, <alain@knaff.lu>,
       <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>
Subject: RE: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Date: Fri, 22 Jan 2010 23:21:06 -0800
Importance: Normal
In-Reply-To: <20100121190952.GA32523@linux-os.sc.intel.com>
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net>
 <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net>
 <1261600243.16916.56.camel@localhost.localdomain>
 <4B476E8D.1030308@compro.net>
 <1263255557.16916.132.camel@local,<20100121190952.GA32523@linux-os.sc.intel.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jan 2010 07:21:06.0472 (UTC) FILETIME=[A0C3A280:01CA9BFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
I think somebody from AMD should review the situation.Clearly something is happening inside their southbridge.CCing Andreas Herrmann from AMD.
Yuhong Bao 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft’s powerful SPAM protection.
http://clk.atdmt.com/GBL/go/196390706/direct/01/