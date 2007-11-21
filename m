Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXKULL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXKULL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXKULLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:11:52 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:12950 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbXKULLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SyR5U/ejOtCoL8E60Gt1x1zFEbp0sjUfYsWljQu7RvMn+aQ35OqYXcaLxudKmnRVrOayFGPj/VGn/M0t5WaAAe37YI0rctvysngB8IHMi1i7bYgRQ/RXGA8NQ6IvvqiiVUmtdonjcJfH25V3OgJjQaTEF6MslgzadKf8MWHA4xA=
Message-ID: <b637ec0b0711210311w348e10bcqb435ec88d8a11e30@mail.gmail.com>
Date: Wed, 21 Nov 2007 12:11:49 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071121103951.GA5788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119151756.GA25446@elte.hu>
	 <b637ec0b0711201238i746ca9bala3812ca93479c6fa@mail.gmail.com>
	 <20071120204103.GC10008@elte.hu>
	 <b637ec0b0711201247m4038a2cds5924ddbd43db6f8e@mail.gmail.com>
	 <20071120215313.GD24156@elte.hu>
	 <b637ec0b0711210050x1fbd741bi9c7550b4ef611598@mail.gmail.com>
	 <20071121103951.GA5788@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Nov 21, 2007 11:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Fabio Comolli <fabio.comolli@gmail.com> wrote:
>
> > To answer your latest mail, again I don't have numbers but from my
> > point ov view:
> >
> > 23.1 < 23.1+ck < 23.8+cfs.24
> >
> > where 23.1+ck is slightly better than vanilla 23.1 and 23.8+cfs.24 is
> > much better than 23.1+ck.
> >
> > My workload is pretty standard, F8+kde+firefox+kmail+amsn, some kernel
> > compile and so on.
>
> do you remember which particular workload improved the most, and in
> roughly whatway? (no need for numbers - subjective impressions are
> accurate enough for this)
>

Firefox, especially when multiple tabs are open. Sometimes I used to
experience some latencies that with cfs.24 are gone.

>         Ingo
>

Regards,
Fabio
