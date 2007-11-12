Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbXKLPjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbXKLPjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXKLPjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:39:32 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60300 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751427AbXKLPjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:39:31 -0500
Date: Mon, 12 Nov 2007 16:39:08 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Yoav Artzi <yoavar@checkpoint.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
Message-ID: <20071112153908.GK9771@stusta.de>
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com> <47387214.2010200@checkpoint.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47387214.2010200@checkpoint.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:32:36PM +0200, Yoav Artzi wrote:

> Well, since the size of the kernel stack is one page,
>...

That's not true.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

