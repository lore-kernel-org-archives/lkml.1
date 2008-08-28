Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYH1NBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYH1NBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYH1NBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:01:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4054 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYH1NBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:01:09 -0400
Date: Thu, 28 Aug 2008 14:01:05 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bryan Wu <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
       Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
Message-ID: <20080828130104.GD11132@sirena.org.uk>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Bryan Wu <cooloney@kernel.org>, perex@perex.cz, lrg@kernel.org,
	Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-4-git-send-email-cooloney@kernel.org> <20080827110143.GB10834@sirena.org.uk> <386072610808272046u270c1302g1102bf1f0bd9b6ee@mail.gmail.com> <20080828101434.GB11132@sirena.org.uk> <s5h3akp9uii.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3akp9uii.wl%tiwai@suse.de>
X-Cookie: To see you is to sympathize.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 02:47:01PM +0200, Takashi Iwai wrote:

> I still postponed to merge Jean's latest patches.  Care to check that
> don't conflict your work and send them together?

No problem from my point of view, though all I'll do is construct a
patch series with Jean's changes at the start so from that point of view
you may as well merge them directly - it doesn't change the work that
needs to be done.
