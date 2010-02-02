Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0BBLkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:40:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34195 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755888Ab0BBLkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:40:51 -0500
Date: Tue, 2 Feb 2010 11:40:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 10/10] sound/soc/s3c24xx/s2c-pcm.c: Fix continuation
 line formats
Message-ID: <20100202114049.GI6566@rakim.wolfsonmicro.main>
References: <cover.1265095093.git.joe@perches.com>
 <56a3bdf490f3fe20c266b43bdc070c7af65b14b9.1265095094.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56a3bdf490f3fe20c266b43bdc070c7af65b14b9.1265095094.git.joe@perches.com>
X-Cookie: Nothing is but what is not.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:22:16PM -0800, Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.

Applied, thanks.
