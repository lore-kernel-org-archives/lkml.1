Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXGZM6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXGZM6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXGZM6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:58:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49545 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310AbXGZM6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:58:07 -0400
Date: Thu, 26 Jul 2007 14:59:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Oliver Pinter <oliver.pntr@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
Message-ID: <20070726125922.GB4041@uranus.ravnborg.org>
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com> <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com> <5263.1185238590@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5263.1185238590@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 08:56:30PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 22 Jul 2007 22:16:14 +0200, Oliver Pinter said:
> 
> > Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
> > for help, because number of person has the question: I have Pentium D,
> > and which CPU chose  I.
> 
> Would it make sense to extend the help sections in arch/i386/Kconfig.cpu to
> list the family/model numbers reported by /proc/cpuinfo?  There's a few cookie
> crumbs in there about new/old Xeons, and that Via Nehemiah chips are 'model 9'.
> Should that be extended to be more complete?

That makes perfect sense to me.
I have sometimes wondered what processor I had in the list.

	Sam
