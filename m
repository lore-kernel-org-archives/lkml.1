Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZHGJ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZHGJ6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZHGJ6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:58:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38251 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755946AbZHGJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:58:47 -0400
Date: Fri, 7 Aug 2009 10:58:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-kernel@vger.kernel.org, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH][2.6.31-rc5] ARM: OMAP: McBSP: Fix ASoC on OMAP1510 by
 fixing API of omap_mcbsp_start/stop
Message-ID: <20090807095846.GB8175@rakim.wolfsonmicro.main>
References: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
X-Cookie: Go 'way!  You're bothering me!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:59:47AM +0300, Jarkko Nikula wrote:
> Simultaneous audio playback and capture on OMAP1510 can cause that second
> stream is stalled if there is enough delay between startup of the audio
> streams.

Applied, thanks.
