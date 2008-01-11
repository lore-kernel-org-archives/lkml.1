Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYAKRvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYAKRvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYAKRvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:51:45 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:33529 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283AbYAKRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:51:43 -0500
X-IronPort-AV: E=Sophos;i="4.24,272,1196658000"; 
   d="scan'208";a="46602007"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Date: Fri, 11 Jan 2008 12:52:02 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Bryan Wu" <cooloney.lkml@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com> <8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com> <20080111103532.2789b74f@poseidon.drzeus.cx>
In-Reply-To: <20080111103532.2789b74f@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801111252.02285.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 11 Jan 2008 17:50:55.0054 (UTC) FILETIME=[839766E0:01C8547A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11 Jan 2008 04:35, Pierre Ossman pondered:
> On Fri, 11 Jan 2008 04:08:53 -0500
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> 
> > On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > So it's far more probable that you've misdiagnosed your error than
> this being the actual problem.
> > 
> > the guys who design the silicon are telling us it doesnt work.  our
> > tests show it not working.  i'm not sure what else you want here.
> > 
> 
> More information. You have not provided any speculation as to why it
> doesn't work, or what you've done to figure it out.

I have been trying to get the detailed information from the hardware (silicon 
designer) guy about why he believes support for 4-bit MMC is not there, but I 
have not heard back yet.

As soon as I hear from them - and either understand why 4-bit MMC doesn't 
work, or if the Blackfin docs are incorrect (either is OK outcome) - I will 
let you know.

Thanks
-Robin
