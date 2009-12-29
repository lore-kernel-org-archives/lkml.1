Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbZL2Ttr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbZL2Ttr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZL2Ttq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:49:46 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52238 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZL2Ttp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:49:45 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 14:49:45 EST
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Tony Lindgren <tony@atomide.com>
Cc: Luke-Jr <luke@dashjr.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <20091229194215.GD3512@atomide.com>
References: <200912290152.16357.luke@dashjr.org>
	 <20091229192407.GA3512@atomide.com> <1262115349.28789.79.camel@gandalf>
	 <20091229194215.GD3512@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 21:49:35 +0200
Message-ID: <1262116175.28789.82.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-12-29 at 11:42 -0800, Tony Lindgren wrote:
> That would be great!

Ok good. So I'll mark all my pending patches as Superseeded or something
better on patchwork then by tomorrow I'll resend all of them, plus the
pull request.

> > Sames goes to Kevin regarding davinci tree. I just have to subscribe in
> > order to be able to send the patches there.
> 
> FYI, I think Kevin is on vacation right now.

good to know. The patch going to Greg right now only marks the fields as
__deprecated so it shouldn't be a big problem to wait a bit.


-- 
balbi

