Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbXDZTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbXDZTBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXDZTBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:01:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53147 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXDZTBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:01:21 -0400
Date: Thu, 26 Apr 2007 20:49:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
cc: hadi@cyberus.ca, Stephen Hemminger <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       cramerj <cramerj@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Leech, Christopher" <christopher.leech@intel.com>, davem@davemloft.net
Subject: RE: [PATCH] IPROUTE: Modify tc for new PRIO multiqueue behavior
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32902B96813@orsmsx414.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.61.0704262048510.506@yvahk01.tjqt.qr>
References: <D5C1322C3E673F459512FB59E0DDC32902B96813@orsmsx414.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 25 2007 10:45, Waskiewicz Jr, Peter P wrote:
>> 
>> BTW, is there any reason this is being cced to lkml?
>
>Since this change affects how tc interacts with the qdisc layer, I cced
>lkml.

Fine with me, at least I get to know that tc could break :)



Jan
-- 
