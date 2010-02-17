Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab0BQKBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:01:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49576 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933004Ab0BQKBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:01:32 -0500
Date: Wed, 17 Feb 2010 10:01:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after final merge (sound tree)
Message-ID: <20100217100132.GA19077@opensource.wolfsonmicro.com>
References: <20100217171923.ea505d0f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217171923.ea505d0f.sfr@canb.auug.org.au>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 05:19:23PM +1100, Stephen Rothwell wrote:

> After merging, today's linux-next build (powerpc allyesconfig) produced
> this warning:

Oh, feh.  My working copy has this warning fixed but apparently that
didn't make it over.  I'll push a refresh out later today.

One of these days mainline will actually build and do something useful
with audio on a system I can use for normal development.  :/
