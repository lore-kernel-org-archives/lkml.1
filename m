Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYHNMCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYHNMCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYHNMCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:02:23 -0400
Received: from www.tglx.de ([62.245.132.106]:50375 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbYHNMCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:02:22 -0400
Date: Thu, 14 Aug 2008 14:02:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Parnell <mparnell@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
In-Reply-To: <680ad8bc0808070757u49e13b3br1f69fb4881dc44ce@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808141400280.3243@apollo.tec.linutronix.de>
References: <680ad8bc0808070757u49e13b3br1f69fb4881dc44ce@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Thu, 7 Aug 2008, Matt Parnell wrote:
> That said, here are system specifics regarding the motherboard and make.
> 
> HP Pavilion dv9205us
> Motherboard: Quanta 30B7
> Processor: AMD Turion 64 x2 3.2ghz, TL-50
> Bios: Phoenix (this is known to be buggy, but until now I had no
> problems since 2.6.24. Compiled on Windows, this bios is.)
> 
> Other than that, I have no pertinent information, at least until
> someone asks something specific. I wouldn't be contacting you all if I
> wasn't at the end of my own resources, as I am part of the Zen kernel
> community, and they can usually help out with these sorts of things.
> (zen-sources.org).
> 
> Anyway, I appreciate any help/response I can get out of this.

Can you please try 2.6.27-rc3 or Linus latest git ? Also please
provide a full boot log.

Thanks,
	tglx
