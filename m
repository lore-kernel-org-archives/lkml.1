Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYCQNcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYCQNcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYCQNbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:31:55 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52947 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYCQNbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:31:55 -0400
Date: Mon, 17 Mar 2008 22:32:29 +0900 (JST)
Message-Id: <20080317.223229.32095947.anemo@mba.ocn.ne.jp>
To: tiwai@suse.de
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, avictor.za@gmail.com
Subject: Re: [PATCH] at73c213: Fix DMA size at the end of DMA buffer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <s5hr6e9pjub.wl%tiwai@suse.de>
References: <s5hzlt1s9up.wl%tiwai@suse.de>
	<20080317.220027.01917573.anemo@mba.ocn.ne.jp>
	<s5hr6e9pjub.wl%tiwai@suse.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 14:21:16 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> > Thank you!  It works fine.  Here is a new patch.
> 
> Thanks for the patch.  So, I should revert your last patch, right?
> It's already on ALSA tree...

Yes, please.  Thank you.

---
Atsushi Nemoto
