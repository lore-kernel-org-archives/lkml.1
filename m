Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZDNHQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZDNHQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZDNHQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:16:27 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:1545 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbZDNHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:16:25 -0400
X-Trace: 177796908/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.21.180/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 79.69.21.180
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAEvV40lPRRW0/2dsb2JhbACBUst4g3wG
X-IronPort-AV: E=Sophos;i="4.40,183,1238972400"; 
   d="scan'208";a="177796908"
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20090414070314.GB29075@linux-sh.org>
References: <1239654768.6542.10.camel@localhost.localdomain>
	 <20090413210030.GA14847@linux-sh.org>
	 <1239658604.6542.28.camel@localhost.localdomain>
	 <20090413215949.GD14847@linux-sh.org>
	 <1239692429.6538.2.camel@localhost.localdomain>
	 <20090414070314.GB29075@linux-sh.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 08:16:15 +0100
Message-Id: <1239693375.6538.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 16:03 +0900, Paul Mundt wrote:

> > 
> Everything about the on-disk format is tied to the VMU. Until that sinks
> in, don't bother sending me email, thanks.

No, everything in the file system is dependent on the specification. The
specification is not dependent on the hardware. Those are the facts.


