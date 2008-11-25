Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbYKYPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbYKYPyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYKYPyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:54:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4463 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYKYPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:54:00 -0500
Date: Tue, 25 Nov 2008 15:53:57 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Randy Dunlap <rdunlap@xenotime.net>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] sound/soc/soc-core.c: cleanup kernel-doc
Message-ID: <20081125155357.GJ12414@sirena.org.uk>
References: <492c18cb.0c636e0a.1c1a.ffffb2b3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492c18cb.0c636e0a.1c1a.ffffb2b3@mx.google.com>
X-Cookie: No one gets sick on Wednesdays.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 11:24:54PM +0800, Qinghuang Feng wrote:
> There is no argument named @clk_id in snd_soc_dai_set_fmt,
> remove its' comment.

> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>

Applied, thanks.

Please make sure to CC relevant maintainers on patches (even for generic
ALSA you've missed off Takashi Iwai here).  It helps make sure patches
don't get missed.
