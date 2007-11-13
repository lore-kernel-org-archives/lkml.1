Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbXKMQJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbXKMQJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXKMQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:09:05 -0500
Received: from www.tglx.de ([62.245.132.106]:53143 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXKMQJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:09:02 -0500
Date: Tue, 13 Nov 2007 17:08:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Lord <liml@rtr.ca>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <4739B245.9040305@rtr.ca>
Message-ID: <alpine.LFD.0.9999.0711131707480.3265@localhost.localdomain>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <4739B245.9040305@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Mark Lord wrote:

> Mark Lord wrote:
> > Andrew Morton wrote:
> > > On Mon, 12 Nov 2007 22:42:32 -0800 "Natalie Protasevich"
> > > <protasnb@gmail.com> wrote:
> > ..
> ..
> > > > Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=9275
> > > > Kernel: 2.6.23
> > > > This is HP notebook nc6320 T2400 945GM
> > > No response from developers
> > ..
> > 
> > I *still* get very slow resume-from-RAM quite often here
> > (new in 2.6.22 kernel, wasn't there in early 2.6.23-rc*).
> ..
> 
> Typo.  That should have said:
> 
> > (new in 2.6.23 kernel, wasn't there in early 2.6.23-rc*).

Just asked that :) Is there a chance to bisect that ?

Thanks,

	tglx
