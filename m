Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbXEXROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbXEXROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbXEXROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:14:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44611 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805AbXEXROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:14:11 -0400
Date: Thu, 24 May 2007 19:14:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524171404.GC4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de> <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705241829000.31549@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 06:29:39PM +0200, Jan Engelhardt wrote:
> 
> On May 23 2007 23:22, Adrian Bunk wrote:
> >
> >And we need only two different inline levels (__always_inline and
> >"let the compiler decide"), not three (__always_inline, inline and
> >"let the compiler decide").
> 
> "inline" is "let the compiler decide". If it is not, then it is "let the
> compiler decide, based on my bias that I think it should be inlined".

Wrong.
"static" is "let the compiler decide".

> 	Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

