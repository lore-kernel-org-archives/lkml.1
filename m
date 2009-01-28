Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZA1VYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZA1VYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZA1VYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:24:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZA1VYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:24:10 -0500
Message-ID: <4980CCD5.4010704@zytor.com>
Date: Wed, 28 Jan 2009 13:23:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu>	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>	 <1233106614.3256.6.camel@localhost.localdomain>	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick>
In-Reply-To: <1233170532.6717.49.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> But now that swab.h has been separated out, we could just stop exporting the
> asm/swab.h bits while still providing a generic C-based implementation to
> userspace.
> 

That makes sense if and only if the generic C-based implementation 
doesn't suck.

	-hpa
