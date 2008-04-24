Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbYDXU3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbYDXU3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbYDXU3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:29:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760349AbYDXU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:29:09 -0400
Date: Thu, 24 Apr 2008 17:28:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Matthias Schwarzott <zzam@gentoo.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: no help text for DVB_TUNER_ITD1000
Message-ID: <20080424172838.5df1da67@gaivota>
In-Reply-To: <20080424202257.GC18854@cs181133002.pp.htv.fi>
References: <20080424202257.GC18854@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Thu, 24 Apr 2008 23:22:57 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> The DVB_TUNER_ITD1000 option introduced by
> commit 1881ee89e0fe03ac5bba9045acb3bea1818f9466
> (V4L/DVB (7571): mt312: Cleanup buffer variables of read/write functions)
> lacks a help text.
> 
> Please add a help text.

Thanks for pointing.

I just noticed and prepared a patch. I should soon add it to devel branch
at -git for people to review. 

Yet, I think we should visit drivers/media/dvb/frontends/Kconfig. There are
lots of "help" there that, IMO, are asking for improvements.

Cheers,
Mauro
