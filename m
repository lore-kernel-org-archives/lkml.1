Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZK0Qra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZK0Qra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 11:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZK0Qr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 11:47:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42054 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751904AbZK0Qr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 11:47:29 -0500
Date: Fri, 27 Nov 2009 16:47:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "A. Porodko" <panda@chelcom.ru>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: Sound support for Neuros OSD2 Davinci based board.
Message-ID: <20091127164733.GC11913@rakim.wolfsonmicro.main>
References: <4B0E7D5E.3080906@chelcom.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E7D5E.3080906@chelcom.ru>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 06:06:38PM +0500, A. Porodko wrote:
> Hello,
> 
> Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
> Patch made against 2.6.32-rc6 kernel.

This doesn't apply against current ASoC.  Could you please regenerate
against this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33
