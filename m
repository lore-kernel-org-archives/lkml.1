Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbXKTUsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbXKTUsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759995AbXKTUrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:47:53 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:63960 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759840AbXKTUrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K/O7OwekH2LZa9y6bZXYbrhL4btHseVgKcem4moxEyBGfLjHb0SWuFYLoqe/yrkTbNrLCC1QJAOMHPi3KZA23qutZgI63XFkEhGWoLni2djrM7bEpzDmLIFK16S01iXhh+VIuN5hzDKNYB/EYtPuNpQ6RhlJK5nIn+2qx5I14Rg=
Message-ID: <b637ec0b0711201247m4038a2cds5924ddbd43db6f8e@mail.gmail.com>
Date: Tue, 20 Nov 2007 21:47:45 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071120204103.GC10008@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119151756.GA25446@elte.hu>
	 <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com>
	 <20071120204103.GC10008@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Nov 20, 2007 9:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Fabio Comolli <fabio.comolli@gmail.com> wrote:
>
> > Hi.
> > First, thanks for this patch. I don't have numbers but working with my
> > laptop feels much better.
>
> curious: what scheduler/kernel version have you used before?

I was using 2.6.23.1 with ck patches.

>
> > Just a question: does the patch include the fix (divide by zero....)
> > you just posted in the stable review for 2.6.23.9?
>
> yeah.

OK, thanks. Have you already tried to apply the patch to 2.6.23.9?
Shall we expect some other rejects?

>
>         Ingo
>

Regards,
Fabio
