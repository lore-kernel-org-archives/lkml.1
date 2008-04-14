Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbYDNS2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbYDNS2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbYDNS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:28:37 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.17]:53421 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbYDNS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:28:35 -0400
Date: Mon, 14 Apr 2008 20:28:14 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: alan@lxorguk.ukuu.org.uk, alan@clueserver.org
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: Again... DMA speed too slow
Message-ID: <4803a23e.V6dRv5RVlZ3pj2Xv%Joerg.Schilling@fokus.fraunhofer.de>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
 <20080414175636.4ea815dc@core>
 <48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
 <20080414182918.4779b8ea@core>
 <44826.198.182.194.170.1208195063.squirrel@clueserver.org>
In-Reply-To: <44826.198.182.194.170.1208195063.squirrel@clueserver.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Apr 2008 18:28:14.0535 (UTC) FILETIME=[4D419570:01C89E5D]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Alan" <alan@clueserver.org> wrote:

>
> >> I am not sure why you mention the term "brave", is it because all known
> >> Linux
> >> distributions still require suid root? In this case, I encourage you to
> >> inform
> >
> > Last time I checked almost all cd burning was being done non root.
>
> Nero for Linux seems to be an exception.  It wants to write to raw devices
> that non-root users do not have permissions for.

Not correct: Nero is not the exception.

All software that implements more than rudimentary functions needs root 
privileges on Linux (*). Some software may not check this in advance and may
later fail with obscure error messages.

*) with future Linux distributions this may change but there is currently no 
known Linux distribution that supports the needed feature.





Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
