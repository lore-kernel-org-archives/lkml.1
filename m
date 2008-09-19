Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYISTZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYISTZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYISTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:25:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2804 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYISTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:25:16 -0400
Date: Fri, 19 Sep 2008 20:25:14 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
Message-ID: <20080919192513.GA18851@sirena.org.uk>
Mail-Followup-To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com> <20080919182036.GA16316@sirena.org.uk> <20080919211437.08db455c@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919211437.08db455c@hskinnemo-gx745.norway.atmel.com>
X-Cookie: Happy feast of the pig!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 09:14:37PM +0200, Haavard Skinnemoen wrote:
> Mark Brown <broonie@sirena.org.uk> wrote:

> > Please submit all ALSA patches to alsa-devel (added to the CC).

> I would if it wasn't listed as subscribers-only...but from a closer
> look, it appears like it's only moderated for non-subscribers. Should I
> resend the patch?

Probably best, yes.  Or if the subscribers thing is an issue you could
send it to Takashi directly.

> Btw, Liam Girdwood's mail address from MAINTAINERS doesn't work.

Yup, he's now lrg@slimlogic.co.uk (I'd updated the address for this
thread when I replied).  He's submitted a patch for MAINTAINERS already
but it's not propagated beyond ALSA git yet.
