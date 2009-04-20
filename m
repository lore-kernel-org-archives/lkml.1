Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZDTTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZDTTrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbZDTTrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:47:00 -0400
Received: from eazy.amigager.de ([213.239.192.238]:35671 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZDTTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:47:00 -0400
Date: Mon, 20 Apr 2009 21:46:59 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090420194659.GA11399@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090420184024.GA10155@dose.home.local> <s5hmyab15bh.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmyab15bh.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 21:41:06 +0200, Takashi Iwai wrote:

[...]

> Could you try the latest Linus git tree?  A fix patch was merged
> after 2.6.30-rc2.  The patch will be merged to later stable kernel, too.

What commit is this? Can it be applied to 2.6.29? As it isn't perfectly
reproducable, I'd like to run 2.6.29 with the patch applied and see if
the problem disappears.

Regards,
Tino
