Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbZEFW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbZEFW23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbZEFW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:27:55 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44910 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761876AbZEFW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:27:54 -0400
Date: Thu, 7 May 2009 00:27:53 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090506222753.GA6728@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <s5hmyab15bh.wl%tiwai@suse.de> <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local> <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428002309.GA29572@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:23:09 +0200, Tino Keitel wrote:

[...]

> I just saw another, major problem: line in doesn't work anymore with
> 2.6.29 and also 2.6.30-rc3 (no usable input level). It works with
> 2.6.27.20.

FYI: I just tried 2.6.28 and line-in was still broken. So the last
working kernel is 2.6.27.

Regards,
Tino
