Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZIJW1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZIJW1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZIJW1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:27:00 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49458 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZIJW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:26:59 -0400
Message-ID: <4AA97D50.40209@freescale.com>
Date: Thu, 10 Sep 2009 17:27:28 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: linuxppc-dev@ozlabs.org, Alemao <xcarandiru@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: MPC85xx External/Internal Interrupts
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com> <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com> <d970ff420909041229hb3aa96dya329e06ea56dd1ac@mail.gmail.com> <20090906110641.GA11350@Chamillionaire.breakpoint.cc> <20090909182857.GB8215@b07421-ec1.am.freescale.net> <20090910131544.GB23433@Chamillionaire.breakpoint.cc> <20090910222400.GB26587@Chamillionaire.breakpoint.cc>
In-Reply-To: <20090910222400.GB26587@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2009 22:27:00.0988 (UTC) FILETIME=[D0D053C0:01CA3265]
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> So the split is a FSL thing.
> What do you thing about making this clear? Adding into every .dts a
> comment right on top or maybe in
> Documentation/powerpc/dts-bindings/fsl/?

Add an fsl/mpic.txt binding that describes this and any other 
pecularities above and beyond the base openpic binding.

-Scott
