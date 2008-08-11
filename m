Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYHKQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYHKQFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYHKQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:05:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50974 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYHKQF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:05:28 -0400
Date: Mon, 11 Aug 2008 19:03:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811160346.GB21292@cs181140183.pp.htv.fi>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811140206.GB3338@cs181140183.pp.htv.fi> <20080811071128.0165be50@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080811071128.0165be50@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
>...
> so before you had for one second "20% expensive, 80% low power" 
> now you have for one second "20% expensive, 20% throttle power, 60% low
> power"
> 
> since throttle power is higher than low/idle power.. you lose.

So what is the intended use case?

Is it for people who bought an Intel Heating 4 but forgot to buy an 
appropriate cooling?

That sounds absurd.

There must be a reason why Intels CPUs support this throttling?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

