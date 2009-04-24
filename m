Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbZDXRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbZDXRri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZDXRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:47:29 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:46585 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186AbZDXRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:47:28 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Apr 2009 13:47:27 EDT
X-Trace: 184404096/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.72.3/None/adrian@newgolddream.info
X-SBRS: None
X-RemoteIP: 79.69.72.3
X-IP-MAIL-FROM: adrian@newgolddream.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYHABSW8UlPRUgD/2dsb2JhbACBUIEwzVWCNoE+BQ
X-IronPort-AV: E=Sophos;i="4.40,243,1238972400"; 
   d="scan'208";a="184404096"
Subject: Re: [Bug #13069] regression in 2.6.29-git3 on SH/Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>
In-Reply-To: <nY3-4PrO6XH.A.QZB.ow85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	 <nY3-4PrO6XH.A.QZB.ow85JB@chimera>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 18:37:18 +0100
Message-Id: <1240594638.4777.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 23:45 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13069
> Subject		: regression in 2.6.29-git3 on SH/Dreamcast
> Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
> Date		: 2009-03-29 19:04 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=123835353115372&w=4
> 

At this point it *looks* as though it was simply a question of
insufficient memory to boot, but I think it needs further testing.
Nobody else seems to have picked it up though.

