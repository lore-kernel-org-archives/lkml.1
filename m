Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXJMPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXJMPc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbXJMPct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:32:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbXJMPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:32:48 -0400
From: Andreas Schwab <schwab@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 2/8] m68k: Atari keyboard ACIA driver cleanup
References: <20071013123123.085686856@mail.of.borg>
	<20071013123412.672481897@mail.of.borg>
X-Yow: WHY are we missing KOJAK?
Date: Sat, 13 Oct 2007 17:32:43 +0200
In-Reply-To: <20071013123412.672481897@mail.of.borg> (Geert Uytterhoeven's
	message of "Sat\, 13 Oct 2007 14\:31\:25 +0200")
Message-ID: <jed4vjrpwk.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> --- a/arch/m68k/atari/atakeyb.c
> +++ b/arch/m68k/atari/atakeyb.c
> @@ -1,5 +1,5 @@
>  /*
> - * linux/atari/atakeyb.c
> + * linux/arch/m68k/atari/atakeyb.c

Please kill that line.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
