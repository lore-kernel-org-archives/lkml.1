Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZLENzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZLENzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZLENzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:55:21 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50354 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbZLENzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:55:20 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Imre Deak <imre.deak@nokia.com>, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/2] [RESEND] Amstrad Delta: add support for LCD contrast
Date: Sat, 5 Dec 2009 14:54:49 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <200911231857.55566.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200911231857.55566.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912051454.52966.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday 23 November 2009 18:57:51 Janusz Krzysztofik napisał(a):
> Initialy submitted on 2009-11-16
> (http://www.spinics.net/lists/linux-omap/msg20629.html).
> Resendig due to fbdev mailing list address changed.
>
> The series consists of 2 patches:
>
>  [PATCH 1/2] omapfb: lcd_ams_delta: add support for contrast control
>  [PATCH 2/2] OMAP: ams_delta_defconfig: enable LCD class device support
>
> It is intended for 2.6.33, if it's not too late.

Hi,

Now that Tony has changed the series status from New to Awaiting Upstream in 
his patchwork queue[1][2], chances of getting it in throungh linux-omap tree, 
like a few other omapfb related patches managed to do lately, seem falling 
down drastically to me if still not answered by anyone involved in omapfb 
development.

Imre,
Could you please take the patches, or give your ack for Tony to take them, or 
just point me on the right way to the get them integrated or NAKed, if none 
of the former is?

Tomi,
I am not sure if you are the right person for bothering here, but maybe you 
could give your comments that would help pushing it forward?

Thanks,
Janusz

[1] http://patchwork.kernel.org/patch/62248/
[2] http://patchwork.kernel.org/patch/62249/
