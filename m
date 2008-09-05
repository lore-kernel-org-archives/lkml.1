Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYIEMic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYIEMic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYIEMiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:38:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1921 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYIEMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:38:24 -0400
Date: Fri, 5 Sep 2008 13:38:21 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/9] ASoC: add Blackfin build options to Kconfig and Makefile of sound soc framework
Message-ID: <20080905123820.GF12383@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	Cliff Cai <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org> <1220610102-7716-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220610102-7716-2-git-send-email-cooloney@kernel.org>
X-Cookie: Universe, n.:
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 06:21:34PM +0800, Bryan Wu wrote:

>  source "sound/soc/davinci/Kconfig"
>  source "sound/soc/omap/Kconfig"
> -
> +source "sound/soc/blackfin/Kconfig"
>  # Supported codecs
>  source "sound/soc/codecs/Kconfig"

Please don't remove the blank line here.  I'll fix this up locally.
Other than that

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
