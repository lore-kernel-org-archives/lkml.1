Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbXERIe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbXERIe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXERIeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:34:50 -0400
Received: from web86902.mail.ukl.yahoo.com ([217.12.13.54]:44021 "HELO
	web86902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755142AbXERIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:34:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=J9EmcgANZ1+o2ZHIrH/t3ethokNiBuj1exGosoMkxDxvJ/B106jP6XqcbkY0moJI219lYrmIL7SfBA12LQN5xkqB8teWB1s6zBZKmdiRfPFJTHNyzIQAd89UJPhJPXzbxdvSMsYp1MdvQgmsGafoI54QBKYXaAMVrD6vSYJ+e9g=;
X-YMail-OSG: czXk8MEVM1nbbBarUfDnE8kRBjyOPZoInNqvTPsF8ixgWO5AxYmFLHZ6TnVG4wvo64m7qIRY4LKwdS.zxDx23AYkH8fpNdwP4WXLWp5zOpre.NYSSEfTbU7XRUewHfrZC7bZbaZRk5aICg--
Date: Fri, 18 May 2007 10:28:06 +0200 (CEST)
From: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH] ide.c: microscopic size and readability optimization
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070517130643.39fbfe29@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <50515.61115.qm@web86902.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Alan Cox <alan@lxorguk.ukuu.org.uk> schrieb:

> On Thu, 17 May 2007 13:25:54 +0200
> Borislav Petkov <bbpetkov@yahoo.de> wrote:
> 
> > -----
> > From: bbpetkov@yahoo.de
> > 
> > A very small size (object file 432 bytes smaller)
> and readability optimization of ide.c
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Bad idea. Now you won't know which of the conditions
> caused the BUG() to
> occur.

Ups, sorry, that I hadn't considered. Nevermind the
noise.

Boris. 



		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de
