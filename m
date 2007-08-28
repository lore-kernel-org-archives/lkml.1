Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXH1GMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXH1GMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXH1GMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:12:39 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:47014 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXH1GMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:12:39 -0400
Date: Tue, 28 Aug 2007 08:07:00 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: john stultz <johnstul@us.ibm.com>, Bob Picco <bob.picco@hp.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070828080700.42234a99@localhost>
In-Reply-To: <20070827173458.5a1ffed1@localhost>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
	<1187905306.6024.24.camel@localhost.localdomain>
	<20070824124631.GF10594@localhost>
	<1187979454.6163.2.camel@localhost.localdomain>
	<20070827173458.5a1ffed1@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 17:34:58 -0300
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:

> | Yea. While I'm still not completely comfortable leaving this up to boot
> | order alone (the ia64 hpet clocksource is clearly causing issues on
> | x86_64), I think this patch is something we need as well.
> 
>  Does -stable need this too?

No  :)

-- 
	Paolo Ornati
	Linux 2.6.22.5 on x86_64
