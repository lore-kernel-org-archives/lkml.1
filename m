Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbYJaLU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbYJaLU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYJaLUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:20:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2808 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYJaLUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:20:47 -0400
Date: Fri, 31 Oct 2008 11:20:46 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, Jon Smirl <jonsmirl@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] API for system clocks (oscillators)
Message-ID: <20081031112045.GC7516@sirena.org.uk>
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com> <9e4733910810300840v7cd45c2cu629d23a27a02c61a@mail.gmail.com> <7a6abd110810300927l428b11f3u509ad31364c08f1f@mail.gmail.com> <9e4733910810300939x40a7afear7a49557604ced628@mail.gmail.com> <7a6abd110810301001r7fc311adifd85fece79cb5c45@mail.gmail.com> <20081030201341.GD13678@sirena.org.uk> <7a6abd110810301315h4f486412u7d88b4a75fc764ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a6abd110810301315h4f486412u7d88b4a75fc764ef@mail.gmail.com>
X-Cookie: A man's house is his hassle.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 09:15:54PM +0100, Jonas Bonn wrote:

> > BTW, on this point I don't know if you've seen Dmitry Baryshkov's work
> > on a generic implementation of the existing clk API.

> No, I haven't... where could I find more information on this?

Here's at least one posting of the series:

	http://lkml.org/lkml/2008/6/26/279

No idea if it was the most recent.  I've also CCed in Dmitry here.
