Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0AON3L (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718Ab0AON3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:29:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49171 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0AON3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:29:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B506D89.7000708@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 14:28:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: adi@hexapodia.org, julia@diku.dk, nm127@freemail.hu, david.vrabel@csr.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: Changelog quality
References: <4B502C6B.7000802@s5r6.in-berlin.de>	<20100115.005445.263291449.davem@davemloft.net>	<tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net>
In-Reply-To: <20100115.012233.202457727.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Date: Fri, 15 Jan 2010 10:17:08 +0100 (CET)
> 
>> I on the other hold the opinion that the changelog has one purpose, to
>> describe the code change.
> 
> %99 of a bug fix is the process and means by which the bug was found,
> therefore the "how was it found" is at least as important as how it is
> fixed.

Well, granted.  The most important part of the changelog is perhaps the
"why", i.e. what problem is being fixed.  How this problem was found is
often worth to describe as well.  It may e.g. help to avoid future
occurrences or hint at further as yet unsolved issues.  But how detailed
to document it is of course subjective; we could argue all day what is
signal and what is noise.  (Which reminds me to stop being noisy and get
back to signal generation.)

> If the script in the commit bothers you, nobody forces you to read it
> or use it.
> 
> If you want more clear markers around the script so you can skim
> past it more efficiently when reading the commit message, then ask
> for that.

I won't ask for that.  The changelog format should not evolve into a
markup language.
-- 
Stefan Richter
-=====-==-=- ---= -====
http://arcgraph.de/sr/
