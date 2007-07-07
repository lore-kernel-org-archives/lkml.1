Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXGGKE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXGGKE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 06:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXGGKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 06:04:19 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:53263 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXGGKET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 06:04:19 -0400
Date: Sat, 7 Jul 2007 12:04:08 +0200
From: DervishD <lkml@dervishd.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about cpufreq governors
Message-ID: <20070707100408.GA19299@DervishD>
Mail-Followup-To: Jan Engelhardt <jengelh@computergmbh.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070706205045.GA2778@DervishD> <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan Engelhardt <jengelh@computergmbh.de> dixit:
> On Jul 6 2007 22:50, DervishD wrote:
> >
> >    What I want to know is if I can choose "ondemand" governor instead
> >of the recommended for AMD64, namely the "conservative" governor, since
> >I will be switching between those two frequencies. I haven't found any
> >information about my CPU regarding latency when switching between
> >frequencies, so I don't know if I will be gaining anything using the
> >"conservative" governor.
> >
> >    Which governor is better suited for a CPU with only two fid's,
> >"ondemand" or "conservative"?
> 
> Depends on what you want. ondemand instantly switches when there is
> something/nothing to do, while conservative uses a threshold (modeled upon
> latency).

    Yes, I know the difference, I'm afraid I didn't ask my question
correctly O:). What I meant is that, since I don't know if my CPU has
latency problems when switching from "slow" freq to "fast" freq, if I
can use "ondemand" safely or if I must use "conservative" due to latency
problems with my CPU.

    Thanks for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
