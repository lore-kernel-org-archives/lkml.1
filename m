Return-Path: <linux-kernel-owner+w=401wt.eu-S933268AbXA2Iab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbXA2Iab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbXA2Iab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 03:30:31 -0500
Received: from ns1.suse.de ([195.135.220.2]:42610 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933268AbXA2Iaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 03:30:30 -0500
Message-ID: <45BDB0AA.2060208@suse.de>
Date: Mon, 29 Jan 2007 09:30:34 +0100
From: Gerd Hoffmann <kraxel@suse.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
References: <200701270222.36060.mista.tapas@gmx.net> <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr> <20070127171859.GB10879@strauss.suse.de>
In-Reply-To: <20070127171859.GB10879@strauss.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Jan Engelhardt <jengelh@linux01.gwdg.de> [2007-01-27 15:53]:
> brokenmodules=..., but that's SUSE's linuxrc.

good enough to boot the rescue system from the install cd without
oopsing and fix up the blacklist file in the installed systen though ;)

Trying to boot into single user is also worth a try.  Some modules are
loaded nevertheless (usb + hid stuff, so you can login with a usb kbd
for example), but most of them are not yet loaded ...

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
