Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbYEMOBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbYEMOBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYEMOBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:01:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3263 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783AbYEMOBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:01:39 -0400
Date: Tue, 13 May 2008 15:01:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>, liam.girdwood@wolfsonmicro.com,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Message-ID: <20080513140132.GG21292@sirena.org.uk>
Mail-Followup-To: "Cai, Cliff" <Cliff.Cai@analog.com>,
	Bryan Wu <cooloney@kernel.org>, liam.girdwood@wolfsonmicro.com,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <1210589112-12208-1-git-send-email-cooloney@kernel.org> <20080512115416.GB23216@sirena.org.uk> <0F1B54C89D5F954D8535DB252AF412FA01F2EF2C@chinexm1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA01F2EF2C@chinexm1.ad.analog.com>
X-Cookie: You have a message from the operator.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:00:58AM +0800, Cai, Cliff wrote:

>  ok,we will implement these two functions later.

So they can be removed for now?

What's the current status of merging the Blackfin ASoC support?  We've
had patches in the ASoC git tree for some time (along with the AD1980
driver) - it'd be good to get everything merged into ALSA.
