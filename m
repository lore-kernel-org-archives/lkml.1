Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXA2LZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXA2LZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXA2LZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:25:49 -0500
Received: from ns.suse.de ([195.135.220.2]:52210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbXA2LZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:25:49 -0500
Message-ID: <45BDD9C2.1020309@suse.de>
Date: Mon, 29 Jan 2007 12:25:54 +0100
From: Gerd Hoffmann <kraxel@suse.de>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
References: <200701270222.36060.mista.tapas@gmx.net> <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr> <20070127171859.GB10879@strauss.suse.de> <45BDB0AA.2060208@suse.de> <Pine.LNX.4.61.0701291211420.32356@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701291211420.32356@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 29 2007 09:30, Gerd Hoffmann wrote:
>> Bernhard Walle wrote:
>>> * Jan Engelhardt <jengelh@linux01.gwdg.de> [2007-01-27 15:53]:
>>> brokenmodules=..., but that's SUSE's linuxrc.
>> good enough to boot the rescue system from the install cd without
>> oopsing and fix up the blacklist file in the installed systen though ;)
> 
> Does not work with components that are compiled-in, for which such a boot
> option would be most helpful.

Is that an real-live issue, with distro kernels being shipped with
almost everything compiled as module these days?

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
