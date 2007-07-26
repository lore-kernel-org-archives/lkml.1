Return-Path: <linux-kernel-owner+w=401wt.eu-S936537AbXGZUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936537AbXGZUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933507AbXGZUKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:10:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55902 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765534AbXGZUKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:10:30 -0400
Date: Thu, 26 Jul 2007 22:11:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oliver Pinter <oliver.pntr@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 00/02] Kconfig cosmetics
Message-ID: <20070726201145.GA6387@uranus.ravnborg.org>
References: <6101e8c40707261154v5d2b839dpf09c0f53916cbab5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40707261154v5d2b839dpf09c0f53916cbab5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 08:54:48PM +0200, Oliver Pinter wrote:
> In this little patch is cosmetic in i386 and x86_64 Kconfig files.
> In first patch add the "Pentium D" and CPU core name  for help, in
> second patch change the order, that logically simplifier when the
> cpu-s sorted by
> time-line.

Hi Oliver.

I have briefly looked through your patches and they looks good.
If they are correct I could not check.

But anyway I usually do not carry arch-specific patches like this
and I request you to send them to Andi Kleen (Cc: on this mail).
You may also rely on Andrew picking them up from lkml.

The patches has:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
