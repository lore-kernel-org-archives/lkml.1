Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZA1XgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZA1XgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZA1Xf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:35:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA1Xf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:35:56 -0500
Message-ID: <4980E9DF.2070101@zytor.com>
Date: Wed, 28 Jan 2009 15:27:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
References: <20090127222825.GA27097@elte.hu>	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>	 <1233106614.3256.6.camel@localhost.localdomain>	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>	 <1233170532.6717.49.camel@brick>	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>	 <1233179884.6717.59.camel@brick>  <4980D913.3000505@zytor.com> <1233182314.6717.66.camel@brick>
In-Reply-To: <1233182314.6717.66.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> Well, that's unfortunate, how about we just export the BSWAP version
> unconditionally and hope pure i386 just goes away someday?
> 

Well, we already have MOVBE coming up, too...

	-hpa
