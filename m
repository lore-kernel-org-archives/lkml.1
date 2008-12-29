Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYL2WS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYL2WS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYL2WSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:18:47 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:7241 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYL2WSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:18:45 -0500
X-Trace: 124242767/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.224/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.224
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEACvbWElQLLDg/2dsb2JhbACBbLwAWJAIhkQ
X-IronPort-AV: E=Sophos;i="4.36,297,1228089600"; 
   d="scan'208";a="124242767"
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA
 Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier@gentoo.org>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20081229214634.GA27064@uranus.ravnborg.org>
References: <1230578246.6496.25.camel@localhost.localdomain>
	 <200812291602.18572.vapier@gentoo.org>
	 <1230586215.6496.28.camel@localhost.localdomain>
	 <200812291636.36303.vapier@gentoo.org>
	 <1230586714.6496.29.camel@localhost.localdomain>
	 <20081229214634.GA27064@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 22:17:53 +0000
Message-Id: <1230589073.6496.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 22:46 +0100, Sam Ravnborg wrote:

> Look for an increase in section mismatch warning or try to
> build with:
> make CONFIG_DEBUG_SECTION_MISMATCH=y
> 

Just rebuilt the whole thing from scratch with that turned on and no
extra warnings at all.

