Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYEMPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYEMPYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYEMPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:24:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbYEMPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:24:27 -0400
Date: Tue, 13 May 2008 16:24:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>, liam.girdwood@wolfsonmicro.com,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Message-ID: <20080513152423.GA649@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>,
	"Cai, Cliff" <Cliff.Cai@analog.com>, liam.girdwood@wolfsonmicro.com,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <1210589112-12208-1-git-send-email-cooloney@kernel.org> <20080512115416.GB23216@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA01F2EF2C@chinexm1.ad.analog.com> <20080513140132.GG21292@sirena.org.uk> <386072610805130807l3e3943e1w24c38b640ab331a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610805130807l3e3943e1w24c38b640ab331a6@mail.gmail.com>
X-Cookie: Postage will be paid by addressee.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:07:16PM +0800, Bryan Wu wrote:
> On Tue, May 13, 2008 at 10:01 PM, Mark Brown

> > We've had patches in the ASoC git tree for some time (along with the AD1980
> >  driver) - it'd be good to get everything merged into ALSA.

> Do you mean there is another version AD1980 in ASoC git tree?

We're carrying both AD1980 and Blackfin platform code.  The AD1980
driver is currently identical to the one you just sent.

Everything is in the dev branch of:

	git://opensource.wolfsonmicro.com/linux-2.6-asoc
