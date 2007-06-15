Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXFOTVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXFOTVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXFOTVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:21:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:61807 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXFOTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,426,1175497200"; 
   d="scan'208";a="257386026"
Message-ID: <4672E6B3.1080205@intel.com>
Date: Fri, 15 Jun 2007 12:21:23 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg>
In-Reply-To: <20070615191804.GC8151@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 19:21:24.0159 (UTC) FILETIME=[5CD794F0:01C7AF82]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
> | 
> | On Jun 15 2007 11:03, Randy Dunlap wrote:
> | >> 
> | >> "use tabs for indents and spaces for alignment"
> | >> 
> | >> If that means you need to use two dozen spaces, then so be it.
> | >
> | >I don't think that's what that rule means, but I didn't write it,
> | >so I'm not absolutely sure about it.
> | >
> | >but we know that tab stops are every 8th character, not 4 :)
> | 
> | Hardly.
> | 
> | 
> | 
> | 
> | 	Jan
> | -- 
> | 
> 
> Jan, as I see from CodingStyle:
> 
> 	"Tabs are 8 characters, and thus indentations are also 8 characters."
> 
> Actually it would be perfect to get strict rules also for math. and log.
> operators being splitted on several lines:

this doesn't say anything about alignment, which was his point :)

Auke
