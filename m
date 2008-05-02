Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbYEBP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbYEBP0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYEBP0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:26:22 -0400
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:64708 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYEBP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:26:21 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 11:26:21 EDT
Date: Fri, 02 May 2008 10:56:16 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] build bug - cx23885
In-reply-to: <20080502135912.GB6847@cvg>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       mchehab@infradead.org
Message-id: <481B2B90.6060508@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20080502135912.GB6847@cvg>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Not sure if it fixed recently - but from today morning sync'ed git
> 
> Kernel: arch/x86/boot/bzImage is ready  (#61)
> Building modules, stage 2.
>  MODPOST 773 modules
>  ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
>  make[1]: *** [__modpost] Error 1
>  make: *** [modules] Error 2
> 
> .config attached

Thanks Cyrill, I'll look into this.

Regards,

Steve

