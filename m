Return-Path: <linux-kernel-owner+w=401wt.eu-S964949AbXGNBiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949AbXGNBiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937474AbXGNBfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:35:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60685 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937466AbXGNBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:35:24 -0400
Date: Sat, 14 Jul 2007 03:34:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Max Alekseyev <maxale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22 booting hangs after "INIT: version 2.86 booting"
Message-ID: <20070714013458.GC3565@stusta.de>
References: <d3dac270707111413j42ac7a0eif032636a9018df66@mail.gmail.com> <d3dac270707111831v508e7c56w966df5bc2e7f855e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d3dac270707111831v508e7c56w966df5bc2e7f855e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 06:31:10PM -0700, Max Alekseyev wrote:
> It happened that this weird behavior was caused by gcc-4.2 compiler.
> After recompiling the kernel with gcc-4.1 all troubles have gone.

Were you using the known-bad 4.2-20070707-1 package from Debian unstable 
or a different compiler?

> Max

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

