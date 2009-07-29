Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZG2M6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZG2M6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZG2M6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:58:44 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:57296 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbZG2M6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:58:41 -0400
Message-ID: <4A704777.70001@mnementh.co.uk>
Date: Wed, 29 Jul 2009 13:58:31 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <4A6F033B.7030302@mnementh.co.uk>	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>	 <20090729115817.GA12223@rakim.wolfsonmicro.main>	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>	 <20090729124233.GA12802@rakim.wolfsonmicro.main> <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
In-Reply-To: <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

>> Indeed.  It's actually much worse than you say, each individual ARM
>> architecture has its own clock API implementation of varying quality and
>> of course there are architectures that don't do the clock API at all.
> 
> Yeah. This is exactly why I don't want to block on the clocklib implementation.

Yeah, good idea... lets ignore the problem until its so big we cant fix 
it at all...
