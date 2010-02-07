Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab0BGXfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:35:54 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:10521 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab0BGXfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:35:52 -0500
X-Trace: 337782259/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.93.110/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.93.110
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An4DALvcbktPRV1u/2dsb2JhbAAIgX/UGIJRggME
X-IronPort-AV: E=Sophos;i="4.49,423,1262563200"; 
   d="scan'208";a="337782259"
Date: Sun, 7 Feb 2010 23:35:48 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
In-Reply-To: <445R0ey9hAI.A.h3.RozbLB@chimera>
Message-ID: <alpine.LSU.2.00.1002072334290.22220@sister.anvils>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.h3.RozbLB@chimera>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Feb 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15202
> Subject		: lockdep warning during elevator_switch
> Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Date		: 2010-01-31 23:55 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=126498212613051&w=4

Yes, still so in 2.6.33-rc7.

Hugh
