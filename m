Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYGaXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYGaXSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYGaXSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:18:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYGaXSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:18:13 -0400
Message-ID: <48924803.5010205@zytor.com>
Date: Thu, 31 Jul 2008 16:17:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [GIT PULL] x86: use arch/x86/include
References: <20080730124952.GA23413@uranus.ravnborg.org>	 <20080730180411.GA7896@elte.hu>	 <20080730184700.GA29710@uranus.ravnborg.org>	 <20080730191907.GD26389@elte.hu>	 <20080730193921.GA4475@uranus.ravnborg.org> <12c511ca0807311615w15c10e15udeefbfeb0b205a@mail.gmail.com>
In-Reply-To: <12c511ca0807311615w15c10e15udeefbfeb0b205a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> So is there a better or worse time to move the include files?
> 
> At the end of a merge window would seem to be
> the least disruptive time.  So we can either hit this
> now, or wait until the next merge.
> 
> -Tony
> 
> [Just did the ia64 move locally with no apparent problems, should I
> commit and send a "please pull"?]

That is clearly the least disruptive time; that's also when we did the 
x86 rename.

	-hpa
