Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZEGUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZEGUmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZEGUmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:42:11 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49515 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZEGUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:42:10 -0400
Date: Thu, 7 May 2009 22:42:08 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090507204208.GA20465@mac.home>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local> <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61> <20090506222753.GA6728@mac.home> <20090507072352.GA6513@mac.home> <s5hy6t92nuz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy6t92nuz.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:45:08 +0200, Takashi Iwai wrote:

[...]

> Could you try the patch below instead?

It doesn't work.

Regards,
Tino
