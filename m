Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXKKFOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXKKFOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 00:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXKKFOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 00:14:32 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48195 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751068AbXKKFOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 00:14:32 -0500
Date: Sun, 11 Nov 2007 06:14:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config
	targets
Message-ID: <20071111051408.GC21669@stusta.de>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 09:55:06PM +0100, Guillaume Chazarain wrote:
> Hi,
> 
> On 11/10/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > The variable K64BIT can now be used to select the
> > value of CONFIG_64BIT.
> 
> Why not calling the environment variable CONFIG_64BIT,
> in preparation of the day when all CONFIG_ variables can
> be passed by environment variables?

What exactly are the use cases where someone would need this?

> Guillaume

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

