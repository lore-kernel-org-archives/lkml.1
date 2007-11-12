Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbXKLKqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbXKLKqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbXKLKqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:46:15 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60048 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755903AbXKLKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:46:14 -0500
Date: Mon, 12 Nov 2007 11:45:51 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071112104551.GH9771@stusta.de>
References: <11943900793940-git-send-email-sam@ravnborg.org> <20071106230451.GA10886@uranus.ravnborg.org> <20071109183602.GD1988@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071109183602.GD1988@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 07:36:02PM +0100, Andreas Herrmann wrote:
>...
> Mostly I have seen the ususal suspects (e.g. missing firmware and
>...

Not related to this patch, but you can set CONFIG_STANDALONE=y with 
KCONFIG_ALLCONFIG for your randconfig compiles.

> Regards,
> 
> Andreas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

