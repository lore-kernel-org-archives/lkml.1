Return-Path: <linux-kernel-owner+w=401wt.eu-S935116AbZDHRzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbZDHRzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZDHRy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:54:58 -0400
Received: from smtp6.welho.com ([213.243.153.40]:36312 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbZDHRy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:54:58 -0400
Date: Wed, 8 Apr 2009 20:54:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: MAX3100
Message-ID: <20090408175455.GA6721@localhost.pp.htv.fi>
References: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090408114427.28788.50640.stgit@t61.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:44:52PM +0100, Alan Cox wrote:
> Thou shalt remember to use 'git add' or there will errors and wrath from on
> list and much wailing and gnashing of teeth.
> 
> Signed-off-by: Alan "I'm hiding" Cox <alan@lxorguk.ukuu.org.uk>
> ---
> 
>  drivers/serial/max3100.c |  927 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 927 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/serial/max3100.c
>...
> --- /dev/null
> +++ b/drivers/serial/max3100.c
>...
> +#include <linux/serial_max3100.h>
>...

Thou shalt remember to also send the header file.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

