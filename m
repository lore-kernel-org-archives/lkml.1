Return-Path: <linux-kernel-owner+w=401wt.eu-S1751900AbZL2TyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbZL2TyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZL2TyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:54:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52848 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZL2TyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:54:02 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Bzo1eDHNnruy8xXlRvcgZ
Date: Tue, 29 Dec 2009 11:53:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Luke-Jr <luke@dashjr.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
Message-ID: <20091229195354.GH3512@atomide.com>
References: <200912290152.16357.luke@dashjr.org>
 <20091229192407.GA3512@atomide.com>
 <1262115349.28789.79.camel@gandalf>
 <20091229194215.GD3512@atomide.com>
 <1262116175.28789.82.camel@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262116175.28789.82.camel@gandalf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <me@felipebalbi.com> [091229 11:48]:
> Hi,
> 
> On Tue, 2009-12-29 at 11:42 -0800, Tony Lindgren wrote:
> > That would be great!
> 
> Ok good. So I'll mark all my pending patches as Superseeded or something
> better on patchwork then by tomorrow I'll resend all of them, plus the
> pull request.

Sounds good. Please keep two separate queues: Fixes for the -rc cycle,
and new code for next merge window.
 
> > > Sames goes to Kevin regarding davinci tree. I just have to subscribe in
> > > order to be able to send the patches there.
> > 
> > FYI, I think Kevin is on vacation right now.
> 
> good to know. The patch going to Greg right now only marks the fields as
> __deprecated so it shouldn't be a big problem to wait a bit.

OK

Tony
