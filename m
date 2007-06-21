Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXFUHiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXFUHiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXFUHiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:38:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:4077 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbXFUHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CECs59rYB5Yn0vjAozCDhKPbnY3EUe7LPEFyCkoXP27wZgRABzy6MeFEWP3C5ClZV1699hzEivz2/sWV8pONGL+fIVXfaaY6IlWKslGBJ2IzUMm4uR9D6WjCkQtCdKmdfQ6nydYuciejye9F+5lA/psC7GN50ZJBoB0+OrVByVw=
Message-ID: <787b0d920706210038t11f1e327hb5e295f7ce5a84a2@mail.gmail.com>
Date: Thu, 21 Jun 2007 03:38:13 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: JIT emulator needs
Cc: "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4679F14F.9050008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070619150824.GH11781@holomorphy.com>
	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
	 <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com>
	 <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>
	 <46797747.9020904@zytor.com>
	 <787b0d920706202021t567b2fefu869a03ef76f245da@mail.gmail.com>
	 <4679F14F.9050008@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Albert Cahalan wrote:

> > Look, let's back up a bit here. At a high level, what exactly do
> > you imagine that this behavior was intended for? I suggest you
> > list some examples of the attacks that are blocked.
> >
> > Can you come up with a reasonable argument that the current behavior
> > is the least painful restriction required to block those attacks?
> > Does the current behavior block any attack that the proposed behavior
> > would not? (list the attacks please)
>
> See above.

Nope. I asked you to justify the existing behavior. Apparently you
are unable to do so. This should be a hint.
