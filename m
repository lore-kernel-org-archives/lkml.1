Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZEVQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZEVQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZEVQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:10:10 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40228 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZEVQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:10:09 -0400
Date: Fri, 22 May 2009 18:10:09 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Feuerer <peter@piie.net>, petkovbb@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Contro
Message-ID: <20090522161009.GA20476@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522140930.GA26580@elf.ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Yep, I don't disagree. But I strongly suspect that if you force the
> fan off and overheat the machine, it will shut down in hardware before
> doing any damage.

s/strongly suspect/definitely know/ ;-)

Reason being that my machine suddenly dropped dead (2 or 3 times maybe),
and when I then reactivated it, the fan made a nice tick....tick....tick noise
as if it tried to start but something blocked it a bit too much.
Shook and rocked the box a bit (not too difficult with a netbook after all ;),
then it worked again and ever since.
Probably a slightly wonky fan, but I'm not sure whether I should care
all that much at the moment.
I _am_ using the shell script currently, but within pretty safe limits
(I'd hope that I'm not insane after all), thus I don't think this negatively
affected fan health or machine.

I cannot really testify that those had been "properly triggered"
emergency shutdowns, but from the looks of it they definitely were,
nothing melted or smoking or whatever.

BIOS v0.3109 (ooold)

Andreas Mohr
