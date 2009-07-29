Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZG2Nvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZG2Nvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZG2Nvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:51:51 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:49066 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbZG2Nvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:51:50 -0400
Message-ID: <4A7053E8.8050303@mnementh.co.uk>
Date: Wed, 29 Jul 2009 14:51:36 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <4A6F033B.7030302@mnementh.co.uk>	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>	 <20090729115817.GA12223@rakim.wolfsonmicro.main>	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>	 <20090729124233.GA12802@rakim.wolfsonmicro.main>	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>	 <4A704777.70001@mnementh.co.uk> <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
In-Reply-To: <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

> Note that I don't need clocklib to get the tmio_mmc driver working for
> my platform. It's something _you_ need for the MFD chips. But you seem
> to want me to fix it for you even though I don't have any particular
> need for it.


Actually, the tmio-mmc driver works perfectly on the MFD chips right 
now. These are the chips it was written to handle.

YOU want to change it, not me. Don't try to turn the argument around.

One more of these "its all your fault and you're deliberately blocking 
me" whines and I *will* start doing just that.

Can we keep it technical now, please?

-Ian (pissed off now)
