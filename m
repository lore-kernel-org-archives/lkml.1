Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbZHDSVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbZHDSVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933119AbZHDSVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:21:44 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:44211 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbZHDSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:21:44 -0400
Message-ID: <4A787C2C.5070000@mnementh.co.uk>
Date: Tue, 04 Aug 2009 19:21:32 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>	 <4A704777.70001@mnementh.co.uk>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org>	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>	 <4A716F1C.2050805@mnementh.co.uk>	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>	 <4A71F2A5.4060206@mnementh.co.uk> <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
In-Reply-To: <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I still do not have info from people about wether non MFD users of the 
tmio-mmc driver have a 1:1 host/card clock capability.

I could really use the information if anyone expects me to sort this 
situation out.

