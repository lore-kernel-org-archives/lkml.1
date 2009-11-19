Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZKSUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZKSUHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZKSUHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:07:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38775
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbZKSUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:07:04 -0500
Date: Thu, 19 Nov 2009 12:07:21 -0800 (PST)
Message-Id: <20091119.120721.252464351.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       skraw@ithnet.com, netdev@vger.kernel.org
Subject: Re: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <OWmO9uyC1hM.A.w9C.NodALB@chimera>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.w9C.NodALB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 17 Nov 2009 00:01:18 +0100 (CET)

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
> Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
> Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
> Date		: 2009-09-20 11:26 (58 days old)
> References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4

Please CC: netdev when reporting networking problems, thank you.

Intel folks can you please take a look at this?  Thanks.
