Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbXBONMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbXBONMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbXBONMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:12:30 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:42454 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708AbXBONM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:12:29 -0500
Date: Thu, 15 Feb 2007 14:09:40 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Neil Brown <neilb@suse.de>
cc: v j <vj.linux@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: <17876.3862.261014.44098@notabene.brown>
Message-ID: <Pine.LNX.4.61.0702151408490.786@yvahk01.tjqt.qr>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
 <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
 <20070214231143.11ff6b46.rdunlap@xenotime.net>
 <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
 <17876.3862.261014.44098@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2007 18:43, Neil Brown wrote:

>> > We seem to have different definitions of open and closed.
>> 
>> Open = 3rd party Linux drivers can be loaded. Closed = No third party
>> Linux drivers can be loaded.
>
>Loading a driver is not at issue.  Anyone may load a driver.

And, after all, because loading is not distribution, you may
rip out export_symbol_gpl and use sysfs directly. It does not
make legal things any safer though, I'd say [ianal].


Jan
-- 
