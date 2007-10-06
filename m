Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXJFIaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXJFIaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXJFIar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:30:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXJFIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:30:46 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
Date: Sat, 6 Oct 2007 10:29:23 +0200
User-Agent: KMail/1.9.5
Cc: Mathieu Chouquet-Stringer <mchouque@free.fr>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu>
In-Reply-To: <m3wsu2u7y6.fsf@bigip.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710061029.24804.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18GyKcLVuELr+nS6J498cHmKjo9Df+oYe6JEF0
 VNEitdnvDyeF8+NRF/osQU6qNR1bjfwN0HHG84VTb0xlNXyikm
 Xb/uaCsSRxfemHUTcawZg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Oktober 2007 19:05 schrieb Mathieu Chouquet-Stringer:
>          Hey there,
>
> I've seen the changes you made in commit b6a2fea39318 and I guess they
> might be responsible for my xargs breakage...
>
> In the kernel source tree, if I run a stupid find | xargs ls, I now get
> this:
> xargs: ls: Argument list too long

Have you tried to remove xarg from the equation above, just in case that it 
stumbles upon the elemination of the reason for its existence in the first 
place..

Pete
