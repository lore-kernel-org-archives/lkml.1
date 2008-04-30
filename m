Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbYD3PP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbYD3PP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbYD3PPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:15:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59124 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756100AbYD3PPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:15:13 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: pupilla@hotmail.com (Marco Berizzi)
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <BAY103-DAV11F874912A45144805FC26B2DE0@phx.gbl>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JrE1V-00082Q-00@gondolin.me.apana.org.au>
Date: Wed, 30 Apr 2008 23:15:09 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi <pupilla@hotmail.com> wrote:
> I know, it is pretty useless this report,
> but I have nothing more than these bitmaps
> and the message in the subject :-(
> 
> http://80.204.235.230/1.jpg
> http://80.204.235.230/2.jpg
> http://80.204.235.230/2.jpg

Could you please take a better shot of this crash the next time
it happens? As it is the right-hand-side of the code section is
missing which makes it hard to determine where exactly it crashed.

Alternatively send me your xfrm_output.o file (or vmlinux).

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
