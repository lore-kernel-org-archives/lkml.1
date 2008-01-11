Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYAKJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYAKJJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760809AbYAKJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:08:57 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:3410 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760657AbYAKJIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:08:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qm1wbnVED59WqPUZ/vwEYWPQ37JVCptjg2G6Bp2aUxknr0p/0E1q3AYHdDJiHNQis7SaWUQAu/cF66i+XqbITMAW2jyXgbFWknOR8hnyojVw4/GxArTTkfIKFMsZ6u43UF/nO0MLECzuq16xsrLBTezKtEd2e56/OKPPI7y1zMY=
Message-ID: <8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
Date: Fri, 11 Jan 2008 04:08:53 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080111094036.4c683791@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	 <20080109082325.212ec90d@poseidon.drzeus.cx>
	 <386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	 <20080110095428.3b93fd18@poseidon.drzeus.cx>
	 <386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	 <20080110125748.416ad0c5@poseidon.drzeus.cx>
	 <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
	 <20080111094036.4c683791@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> "Bryan Wu" <cooloney.lkml@gmail.com> wrote:
> > We were told this is an hardware design issue, so please help us to
> > workaround it in software side with Mike's patch.
>
> So it's far more probable that you've misdiagnosed your error than this being the actual problem.

the guys who design the silicon are telling us it doesnt work.  our
tests show it not working.  i'm not sure what else you want here.

> The fact that 4-bit MMC support has been present for some time and you're only now seeing a problem further supports that.

not in the least actually.  we just started developing the driver.  it
has seen no real world use.  we've been testing things internally to
make sure the setup is sane.  4-bit MMC is coming up as not working.
-mike
