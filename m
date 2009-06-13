Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZFMADR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZFMADR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZFMADC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:03:02 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52130 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZFMADB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eIqC9VGIEpYiqPZb06DutiCv93zmqQE0Hxl1O13res42ZKz7+bLLsxv3QW1ctn8EFW
         S3MoCcFgHShAKt4PB93mWMUHGT5fI4ePbdhYT9nXrW5BabgQQwDVYcEu0KUsCZn5WORM
         uIg66VY7tgfUnoh/teZg/rXiUJ837Pqzlyvq4=
MIME-Version: 1.0
In-Reply-To: <200906122341.30518.arnd@arndb.de>
References: <200906121247.50745.arnd@arndb.de> <200906121329.33473.arnd@arndb.de> 
	<8bd0f97a0906120435w16a1f46ewd9ad94ee35c04e6e@mail.gmail.com> 
	<200906122341.30518.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 20:02:43 -0400
Message-ID: <8bd0f97a0906121702r42e75204sd81c10eaa6be6d27@mail.gmail.com>
Subject: Re: [PATCH] Blackfin: sync termios header changes with x86
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 17:41, Arnd Bergmann wrote:
> On Friday 12 June 2009, Mike Frysinger wrote:
>> > If you want a working version of this file, best copy it from avr32
>> > or frv. Or just wait for the asm-generic version.
>>
>> is asm-generic going to be in 2.6.31 ?  otherwise i'd prefer to have
>> Blackfin fixed now rather than 2.6.32+
>
> I certainly hope it does. I've sent the pull request yesterday,
> so it's probably still in Linus' queue for trees to merge, unless
> he dropped it.

then i'm fine with fixing the header post your pull by switching to
asm-generic.  thanks!
-mike
