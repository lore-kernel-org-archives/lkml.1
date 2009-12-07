Return-Path: <linux-kernel-owner+w=401wt.eu-S935631AbZLGVdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631AbZLGVdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935592AbZLGVdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:33:10 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62837 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935561AbZLGVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:33:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ocfXaqvS1po83VPz5TsAK
Date: Mon, 7 Dec 2009 13:32:50 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Imre Deak <imre.deak@nokia.com>, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-fbdev@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] [RESEND] Amstrad Delta: add support for LCD
 contrast
Message-ID: <20091207213250.GI24013@atomide.com>
References: <200911231857.55566.jkrzyszt@tis.icnet.pl>
 <200912051454.52966.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200912051454.52966.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091205 05:54]:
> Monday 23 November 2009 18:57:51 Janusz Krzysztofik napisał(a):
> > Initialy submitted on 2009-11-16
> > (http://www.spinics.net/lists/linux-omap/msg20629.html).
> > Resendig due to fbdev mailing list address changed.
> >
> > The series consists of 2 patches:
> >
> >  [PATCH 1/2] omapfb: lcd_ams_delta: add support for contrast control
> >  [PATCH 2/2] OMAP: ams_delta_defconfig: enable LCD class device support
> >
> > It is intended for 2.6.33, if it's not too late.
> 
> Hi,
> 
> Now that Tony has changed the series status from New to Awaiting Upstream in 
> his patchwork queue[1][2], chances of getting it in throungh linux-omap tree, 
> like a few other omapfb related patches managed to do lately, seem falling 
> down drastically to me if still not answered by anyone involved in omapfb 
> development.
> 
> Imre,
> Could you please take the patches, or give your ack for Tony to take them, or 
> just point me on the right way to the get them integrated or NAKed, if none 
> of the former is?
> 
> Tomi,
> I am not sure if you are the right person for bothering here, but maybe you 
> could give your comments that would help pushing it forward?

I'd prefer Tomi to merge all the drivers/video/omap code rather
than merge it via linux-omap tree. Ideally with an ack from
Imre where possible.

Tony

 
> Thanks,
> Janusz
> 
> [1] http://patchwork.kernel.org/patch/62248/
> [2] http://patchwork.kernel.org/patch/62249/
