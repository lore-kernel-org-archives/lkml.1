Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZIPC5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZIPC5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZIPC5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:57:04 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:47541 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbZIPC5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=J7f3hY+igTZKljR6egUq+rr1UPgBjtbgNTqH1QUIU9qllxWeTLtkyLU7oDWx7P9ub6
         n7iofhRL3/4oWcMhWMYXgaUqXG4+5dFSo+PukMXPiWSVZUjeT5QTDsZnUooJf2IxdHgZ
         HbwCYN7JxU1M24sPBueaUneVoWVWuhbvjNyvE=
MIME-Version: 1.0
In-Reply-To: <1252967767.11643.286.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252961412.11643.215.camel@desktop> <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com> 
	<1252962263.11643.232.camel@desktop> <8bd0f97a0909141407i26b39f9bq133a62be381601b5@mail.gmail.com> 
	<1252963292.11643.259.camel@desktop> <8bd0f97a0909141517i3535bb84j4cbac0cd986d4914@mail.gmail.com> 
	<1252967767.11643.286.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 22:56:46 -0400
Message-ID: <8bd0f97a0909151956k6cc20944we1ccb6c5188c4edb@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 18:36, Daniel Walker wrote:
> If you ultimately don't correct these changes, I'd ask that in the
> future you submit pull requests for the blackfin architecture instead of
> sending individual patches ..

you havent been following anything related to how Blackfin (or any
arch?) patches are merged.  this patch series is for review only from
my tree.  no one is picking these up because they've already been
picked up.
-mike
