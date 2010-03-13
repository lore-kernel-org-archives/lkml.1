Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0CMHw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 02:52:57 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50983 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754445Ab0CMHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 02:52:55 -0500
Date: Sat, 13 Mar 2010 08:52:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] fix for msm_sdcc MMC driver for 2.6.34-rc1
Message-ID: <20100313075248.GK12554@elf.ucw.cz>
References: <1268081936.14857.60.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268081936.14857.60.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-08 12:58:56, Daniel Walker wrote:
> Just one small trivial fix.
> 
> The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc2
> 
> are available in the git repository at:
> 
>   git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc
> 
> Roel Kluin (1):
>       msm_sdcc.c: missing brackets in msmsdcc_resume()

Cool, 2.6.34-rc1 boots on HTC Dream, as did 2.6.33. Does this mean I
should try to set up MMC, too? MMC worked in your -working-mmc tree in
2.6.33...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
