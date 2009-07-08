Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZGHR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZGHR2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZGHR2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:28:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54923 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZGHR2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fulSJxtn+wvkTq3qJN128RZyrOt4N5eH6T9VMnF/U2zs+ROiiH7CBGh6B2SlV5DcxC
         xDu3Jj20ZC10wSsNk8/4EysXBSbkhdbjQk5MxCRBsA1r4CSXp0cGwfx1hQqWnlbr0DOq
         KWAqhDi2ja9EnxAnXK8VBelvdKmW0sY7UtyDE=
MIME-Version: 1.0
In-Reply-To: <1247067147.4382.80.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247067147.4382.80.camel@ht.satnam>
Date: Wed, 8 Jul 2009 19:28:01 +0200
Message-ID: <63386a3d0907081028s4a36fccen9cea9a316e2ef4c6@mail.gmail.com>
Subject: Re: [PATCH 29/44] includecheck fix: drivers/spi, amba-pl022.c
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:

> fix the following 'make includecheck' warnings:
>
>  drivers/spi/amba-pl022.c: linux/delay.h is included more than once.
>  drivers/spi/amba-pl022.c: linux/errno.h is included more than once.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

David are you merging this?

Linus Walleij
