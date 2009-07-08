Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZGHRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZGHRog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZGHRo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:44:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZGHRo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:44:29 -0400
Subject: Re: [PATCH 29/44] includecheck fix: drivers/spi, amba-pl022.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <63386a3d0907081028s4a36fccen9cea9a316e2ef4c6@mail.gmail.com>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247067147.4382.80.camel@ht.satnam>
	 <63386a3d0907081028s4a36fccen9cea9a316e2ef4c6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 23:12:47 +0530
Message-Id: <1247074967.4382.115.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 19:28 +0200, Linus Walleij wrote:
> 2009/7/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> 
> > fix the following 'make includecheck' warnings:
> >
> >  drivers/spi/amba-pl022.c: linux/delay.h is included more than once.
> >  drivers/spi/amba-pl022.c: linux/errno.h is included more than once.
> 
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> 
> David are you merging this?
> 

This is a big patchset, So better me or Sam will send this to Linus
after collecting some more ACKs.

Thanks,
--
JSR

