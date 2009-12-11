Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZLKJzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZLKJzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZLKJzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:55:05 -0500
Received: from smtp.nokia.com ([192.100.122.233]:42757 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZLKJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:55:04 -0500
Subject: Re: [PATCH 0/2] [RESEND] Amstrad Delta: add support for LCD
 contrast
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       "Deak Imre (Nokia-D/Helsinki)" <imre.deak@nokia.com>,
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
Date: Fri, 11 Dec 2009 11:53:43 +0200
Message-ID: <1260525223.9700.86.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Dec 2009 09:53:45.0482 (UTC) FILETIME=[D43266A0:01CA7A47]
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

I talked with Imre, and he's not too keen on maintaining the old omapfb,
so I'll take over it. And perhaps it's easier to have all omap display
related patches in one place.

 Tomi


