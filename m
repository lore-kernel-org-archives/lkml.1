Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbYEHPFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbYEHPFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYEHPEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117AbYEHPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:04:52 -0400
Date: Thu, 8 May 2008 08:04:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       jengelh@computergmbh.de, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk
Subject: Re: 2.6.26-rcX VC console scrolling regression
In-Reply-To: <20080507230247.96b37830.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805080804110.3024@woody.linux-foundation.org>
References: <20080507.214637.193700986.davem@davemloft.net> <20080507230247.96b37830.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Andrew Morton wrote:
> 
> If we continue in this way, patch-2.6.26 will consist solely of:
> 
> --- a/Makefile
> +++ a/Makefile
> @@ -1,6 +1,6 @@
>  VERSION = 2
>  PATCHLEVEL = 6
> -SUBLEVEL = 25
> +SUBLEVEL = 26
>  EXTRAVERSION =
>  NAME = Funky Weasel is Jiggy wit it
>  
> :(

Why the frowny face. That would be beautiful ;)

		Linus
