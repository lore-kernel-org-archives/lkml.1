Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158Ab0AQAvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0AQAvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 19:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302Ab0AQAvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 19:51:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 19:51:05 -0500
Message-ID: <4B525ED7.3000005@zytor.com>
Date: Sat, 16 Jan 2010 16:50:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
References: <20100116170338.GA17175@elte.hu>	 <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>	 <20100116205342.GA5725@lenovo> <1263676617.14137.679.camel@localhost.localdomain>
In-Reply-To: <1263676617.14137.679.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 01:16 PM, Ian Campbell wrote:
> 
> Although I think Linus' basic point is still valid -- why isn't a valid
> SS needed for 32 bit? The selectors have real meaning there even for
> native, don't they?
> 

No, they aren't used for native for either 32 or 64 bits.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

