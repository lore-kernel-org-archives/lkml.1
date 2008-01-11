Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYAKJft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYAKJft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759872AbYAKJfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:35:41 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:39130 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761392AbYAKJfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:35:39 -0500
Date: Fri, 11 Jan 2008 10:35:32 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080111103532.2789b74f@poseidon.drzeus.cx>
In-Reply-To: <8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	<20080109082325.212ec90d@poseidon.drzeus.cx>
	<386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	<20080110095428.3b93fd18@poseidon.drzeus.cx>
	<386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	<20080110125748.416ad0c5@poseidon.drzeus.cx>
	<386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
	<20080111094036.4c683791@poseidon.drzeus.cx>
	<8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 04:08:53 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > So it's far more probable that you've misdiagnosed your error than this being the actual problem.
> 
> the guys who design the silicon are telling us it doesnt work.  our
> tests show it not working.  i'm not sure what else you want here.
> 

More information. You have not provided any speculation as to why it doesn't work, or what you've done to figure it out. You haven't even described how it fails, just that it does. No information about what cards you've tested and how you've tested them to confirm that your theory on 4-bit data is accurate.

You have no track record with me, and you're proposing something that goes against all known information. So you have to understand that I'm sceptical about your claims. I won't dismiss them off hand, but I need to be convinced you haven't made a mistake when coming to this conclusion.

> > The fact that 4-bit MMC support has been present for some time and you're only now seeing a problem further supports that.
> 
> not in the least actually.  we just started developing the driver.  it
> has seen no real world use.  we've been testing things internally to
> make sure the setup is sane.  4-bit MMC is coming up as not working.

Fair enough. But if it's a new driver that hasn't seen real-world testing, then there might be other bugs influencing things.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
