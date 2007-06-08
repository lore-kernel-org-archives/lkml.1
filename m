Return-Path: <linux-kernel-owner+w=401wt.eu-S937713AbXFHFQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937713AbXFHFQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXFHFQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:16:37 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1936 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbXFHFQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:16:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 22:16:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <4668C538.9090006@redhat.com>
Message-ID: <Pine.LNX.4.64.0706072215260.3454@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <4668155B.4020705@redhat.com>
 <20070607195659.c695c87d.dada1@cosmosbay.com> <46684DED.6000907@redhat.com>
 <Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com>
 <20070607130319.8fd96e03.akpm@linux-foundation.org> <4668C538.9090006@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andrew Morton wrote:
> > Absolutely.  Let's get them into their final form now, rather than letting
> > some intermediate interface escape out into a major kernel release.
> 
> Even if Linus' redirection is adopted, these interfaces should still be
> fixed up.  No need to rely on hacks if we can still fix up the interfaces.

Indeed. I still think that adding O_NONSEQFD is a good idea, independently 
on the other interfaces.


- Davide


