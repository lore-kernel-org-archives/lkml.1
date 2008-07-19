Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYGSMSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYGSMSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYGSMSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:18:25 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:15708 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbYGSMSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:18:24 -0400
X-Trace: 45983894/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/81.1.86.85
X-SBRS: None
X-RemoteIP: 81.1.86.85
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACh4gUhRAVZV/2dsb2JhbACBWqw8
X-IronPort-AV: E=Sophos;i="4.31,214,1215385200"; 
   d="scan'208";a="45983894"
Subject: Re: [PATCH] input: Clean up maple keyboard driver
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <20080718224323.GA19263@linux-sh.org>
References: <1213559019.22707.12.camel@localhost.localdomain>
	 <20080718224323.GA19263@linux-sh.org>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 13:17:59 +0100
Message-Id: <1216469879.8959.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 07:43 +0900, Paul Mundt wrote:
> On Sun, Jun 15, 2008 at 08:43:39PM +0100, Adrian McMenamin wrote:
> > Have a single probe function instead of a probe and a connect function.
> > Also tidy a comment.
> > 1 files changed, 33 insertions(+), 48 deletions(-)
> > 
> > 
> > Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> Ok, so I was going to take this through my tree, but it doesn't apply any
> more. Please send an updated version that can be merged.

What is the problem? Is it just a badly formed patch or has something
changed elsewhere?

I'll have a look but as I have no issues I'm not sure what is wrong.

