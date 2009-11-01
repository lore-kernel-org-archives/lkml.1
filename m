Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZKAU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZKAU7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 15:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZKAU7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 15:59:53 -0500
Received: from icculus.org ([67.106.77.212]:46095 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZKAU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 15:59:53 -0500
Date: Sun, 1 Nov 2009 15:59:56 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.local
To: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
Message-ID: <alpine.OSX.1.10.0911011540400.53392@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Am I the only one who sees this as nothing bloat for its own sake?

I posted a fairly large list of benefits here:  http://icculus.org/fatelf/

Some are more far-fetched than others, I will grant. Also, I suspect most 
people will find one benefit and ten things they don't care about, but 
that benefit is different for different people. I'm confident that the 
benefits far outweigh the size of the kernel patch.

> Did I miss a massive drop in intelligence of Linux users, causing them
> to no longer be capable of picking the correct file themselves?

Also known as "market saturation."   :)

(But really, there are benefits beyond helping dumb people, even if 
helping dumb people wasn't a worthwhile goal in itself.)

> As an embedded systems guy, I'm more concerned about precious flash
> space going to waste than about some hypothetical convenience.

I wouldn't imagine this is the target audience for FatELF. For embedded 
devices, just use the same ELF files you've always used.

--ryan.

