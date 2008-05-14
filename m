Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYENWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYENWl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYENWlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:41:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:18230 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbYENWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:41:13 -0400
Subject: Re: [PATCH] ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
From: Daniel Walker <dwalker@mvista.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080514210958.GA7831@atomide.com>
References: <20080505203154.GF11462@traven>
	 <1210608572.22306.4.camel@localhost.localdomain>
	 <20080514210958.GA7831@atomide.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 15:41:07 -0700
Message-Id: <1210804867.22306.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 14:09 -0700, Tony Lindgren wrote:
> Hi,
> 
> * Daniel Walker <dwalker@mvista.com> [080512 09:09]:
> > 
> > On Mon, 2008-05-05 at 22:31 +0200, Matthias Kaehlcke wrote:
> > > ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
> > > mutex. Convert it to the mutex API
> > > 
> > 
> > I submitted an identical patch to Tony in January .. I assumed it was
> > making it's way through the ARM tree .. I'm surprised it's not in
> > mainline yet ..
> > 
> > Tony any status on this?
> 
> Hmm, I can't seem to find your patch and it does not show up in git-log
> either in linux-omap. Maybe I never got it or never applied it?
> 
> Do you have a link for you patch in the mailing list archives so I can
> look into it further?
> 
> Regards,

http://marc.info/?l=linux-omap&m=120063553504911&w=2

We had a discussion about it as I recall.

Daniel

