Return-Path: <linux-kernel-owner+w=401wt.eu-S1751059AbXA2LMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbXA2LMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXA2LMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:12:24 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38236 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXA2LMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:12:23 -0500
Date: Mon, 29 Jan 2007 12:12:05 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Gerd Hoffmann <kraxel@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
In-Reply-To: <45BDB0AA.2060208@suse.de>
Message-ID: <Pine.LNX.4.61.0701291211420.32356@yvahk01.tjqt.qr>
References: <200701270222.36060.mista.tapas@gmx.net>
 <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr> <20070127171859.GB10879@strauss.suse.de>
 <45BDB0AA.2060208@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2007 09:30, Gerd Hoffmann wrote:
>Bernhard Walle wrote:
>> * Jan Engelhardt <jengelh@linux01.gwdg.de> [2007-01-27 15:53]:
>> brokenmodules=..., but that's SUSE's linuxrc.
>
>good enough to boot the rescue system from the install cd without
>oopsing and fix up the blacklist file in the installed systen though ;)

Does not work with components that are compiled-in, for which such a boot
option would be most helpful.


	-`J'
-- 
