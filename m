Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZKJLSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZKJLSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZKJLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:18:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41017 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZKJLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:18:08 -0500
Date: Tue, 10 Nov 2009 11:46:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: zaurus-devel@www.linuxtogo.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: spitz battery driver
Message-ID: <20091110104634.GA1395@ucw.cz>
References: <20091109135813.GA1385@ucw.cz> <f17812d70911091948p5331f11djc887443559b233db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70911091948p5331f11djc887443559b233db@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-10 11:48:16, Eric Miao wrote:
> On Mon, Nov 9, 2009 at 9:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > This introduces battery driver for spitz. For now it is
> > monitoring&debug-only.
> >
> 
> This is a good move. However, I assume the patch is still RFC now.
> Or basically the coding style cleanup can be separated into another
> patch?

Its rfc now. Parts of codingstyle cleanup should already be in your
tree, I'll rediff it later.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
