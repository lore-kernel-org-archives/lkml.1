Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZFYHtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZFYHtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZFYHtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:49:42 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59819 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZFYHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ng55L/DHvXqqOQdVnEuLxvOlpfyQ+YSBXoh8J/Me6+kzjQQjIt9/9tjoDuat6gifmu
         uex6FI4VzCIQ/IrfP6FQHvgWO9wFD/4DEduUiKBoy3NuyOb3tGClT6lJPR1+U5UgJMzS
         WoY2NzRZgWacKwXwuI4Mpi8wIjYo/YkGB7cU8=
MIME-Version: 1.0
In-Reply-To: <4A42DB93.8020503@bluewatersys.com>
References: <4A3F017B.2010409@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com>
	 <4A42DB93.8020503@bluewatersys.com>
Date: Thu, 25 Jun 2009 09:49:43 +0200
Message-ID: <63386a3d0906250049j2a2ebf08ka7e4d10b0c4f4a0d@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Ryan Mallon <ryan@bluewatersys.com>:

> Linus, is this still okay by you?

I'm a novice in MTD, sorry. But AFAICT yes.

Linus Walleij
