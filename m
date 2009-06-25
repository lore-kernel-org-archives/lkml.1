Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZFYAId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZFYAId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZFYAIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:08:23 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63346 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZFYAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FMRJDSkKQeDwjJu0wmAlABWXBxdJhe0pScoNT7gg3v8zD2TG0d8SdVZWb5060HtDvQ
         ZH7sWl+38yS+jviYGqnkcWZ9xPlT+lIrSMdASN9lIWz+lzC/nUKkRjzdvdmU52uja8OM
         uHmlnTEQVnd3iquZi6XJgFhyRAgaeknMA06Lg=
MIME-Version: 1.0
In-Reply-To: <4A42BDF3.10901@bluewatersys.com>
References: <4A42BDF3.10901@bluewatersys.com>
Date: Thu, 25 Jun 2009 02:08:23 +0200
Message-ID: <63386a3d0906241708j1ecbf8acwe47f9dbefd504c00@mail.gmail.com>
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: akpm@linux-foundation.org, linux kernel <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Ryan Mallon <ryan@bluewatersys.com>:

> It was suggested I send the following patch via you as David Woodhouse
> is currently busy.

Actually it was David Brownell (the SPI maintainer) I was thinking of
that was sort of busy lately, perhaps Woodhouse (the MTD maintainer)
is less busy ... let's see.

Linus Walleij
