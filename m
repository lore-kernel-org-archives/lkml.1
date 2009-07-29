Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZG2M7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZG2M7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZG2M7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:59:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40776 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754619AbZG2M7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:59:47 -0400
Date: Wed, 29 Jul 2009 13:59:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729125942.GA13337@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
 <4A6F033B.7030302@mnementh.co.uk>
 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
 <20090729115817.GA12223@rakim.wolfsonmicro.main>
 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
 <20090729124233.GA12802@rakim.wolfsonmicro.main>
 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
X-Cookie: Without fools there would be no wisdom.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 09:51:30PM +0900, Magnus Damm wrote:
> On Wed, Jul 29, 2009 at 9:42 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:

> > That's not actually abundantly clear for the audio stuff, or rather the
> > audio stuff would like additional features like constraint based
> > configuration.

> Without knowing too much about this, wouldn't camera sensors want
> similar features?

They may well but I'm not familiar with them; I can speak much more
confidently about audio.
