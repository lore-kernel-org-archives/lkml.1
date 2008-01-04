Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYADTne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYADTne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 14:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYADTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 14:43:27 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55832 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYADTn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 14:43:26 -0500
Date: Fri, 4 Jan 2008 20:43:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080104194328.GA32091@uranus.ravnborg.org>
References: <20080103213255.GA21811@uranus.ravnborg.org> <Pine.LNX.4.64.0801032308400.26693@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801032308400.26693@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 11:33:44PM +0100, Jan Engelhardt wrote:
> 
> On Jan 3 2008 22:32, Sam Ravnborg wrote:
> >
> >On top of this I have my personal todo items such as:
> >- modern ncurses interface for menuconfig (ala tig, htop and others)
> 
> Sorry.. your comparison {menuconfig, htop} raises an "incompatible
> pointer passed" on my side. Please explain :)

htop is a nice ncurses based interface to top.

Try "F2" and see a nice layout for a menu structure remotely
similar to menuconfig.
I could mention a few more - this was more to say that there
exist much beter looking ncurses based tools than menuconfig.

> 
> >TODO items (from my mailbox - I have plenty more)
> >=================================================
> >- allow kconfig to accept overrides (Jan Engelhart)
> >  maybe there is a patch, needs followup
> 
> Indeed there is/was a patch. Well, the one I sent last time.
> http://lkml.org/lkml/2007/10/18/206
> 
> I have updated it to Linus's current treetop.
> git://computergmbh.de/linux 'kconfig' branch;

Applied after fixing one checkpatch error.
I did not care about the lines longer than 80 in this case.
I also restored the original Cc: list.

	Sam
