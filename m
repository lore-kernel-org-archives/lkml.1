Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYENVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYENVKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYENVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:10:09 -0400
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:50580 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYENVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:10:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18jJi+mHbXY7Yw6G6sa6CEk
Date: Wed, 14 May 2008 14:09:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
Message-ID: <20080514210958.GA7831@atomide.com>
References: <20080505203154.GF11462@traven> <1210608572.22306.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210608572.22306.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Daniel Walker <dwalker@mvista.com> [080512 09:09]:
> 
> On Mon, 2008-05-05 at 22:31 +0200, Matthias Kaehlcke wrote:
> > ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
> > mutex. Convert it to the mutex API
> > 
> 
> I submitted an identical patch to Tony in January .. I assumed it was
> making it's way through the ARM tree .. I'm surprised it's not in
> mainline yet ..
> 
> Tony any status on this?

Hmm, I can't seem to find your patch and it does not show up in git-log
either in linux-omap. Maybe I never got it or never applied it?

Do you have a link for you patch in the mailing list archives so I can
look into it further?

Regards,

Tony
