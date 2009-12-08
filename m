Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZLHJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZLHJXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZLHJXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:23:19 -0500
Received: from smtp.nokia.com ([192.100.122.233]:47366 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZLHJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:23:15 -0500
Subject: Re: [PATCH 0/2] [RESEND] Amstrad Delta: add support for LCD
 contrast
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>,
       "Deak Imre (Nokia-D/Helsinki)" <imre.deak@nokia.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091207213250.GI24013@atomide.com>
References: <200911231857.55566.jkrzyszt@tis.icnet.pl>
	 <200912051454.52966.jkrzyszt@tis.icnet.pl>
	 <20091207213250.GI24013@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 11:21:36 +0200
Message-ID: <1260264096.2342.104.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2009 09:21:41.0675 (UTC) FILETIME=[DA477FB0:01CA77E7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 22:32 +0100, ext Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091205 05:54]:
> > Monday 23 November 2009 18:57:51 Janusz Krzysztofik napisał(a):
> > > Initialy submitted on 2009-11-16
> > > (http://www.spinics.net/lists/linux-omap/msg20629.html).
> > > Resendig due to fbdev mailing list address changed.
> > >
> > > The series consists of 2 patches:
> > >
> > >  [PATCH 1/2] omapfb: lcd_ams_delta: add support for contrast control
> > >  [PATCH 2/2] OMAP: ams_delta_defconfig: enable LCD class device support
> > >
> > > It is intended for 2.6.33, if it's not too late.
> > 
> > Hi,
> > 
> > Now that Tony has changed the series status from New to Awaiting Upstream in 
> > his patchwork queue[1][2], chances of getting it in throungh linux-omap tree, 
> > like a few other omapfb related patches managed to do lately, seem falling 
> > down drastically to me if still not answered by anyone involved in omapfb 
> > development.
> > 
> > Imre,
> > Could you please take the patches, or give your ack for Tony to take them, or 
> > just point me on the right way to the get them integrated or NAKed, if none 
> > of the former is?
> > 
> > Tomi,
> > I am not sure if you are the right person for bothering here, but maybe you 
> > could give your comments that would help pushing it forward?
> 
> I'd prefer Tomi to merge all the drivers/video/omap code rather
> than merge it via linux-omap tree. Ideally with an ack from
> Imre where possible.

And I, on the other hand, would like to keep away from the old omapfb
driver =).

Imre, do you still want to be the maintainer of the old omapfb, or how
should we handle it? I didn't have any plans to maintain it, but then
again, perhaps it wouldn't be too much of a burden to have the
(hopefully) few patches for old omapfb in the DSS2 tree.

 Tomi


