Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbXH2KfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbXH2KfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXH2KfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:35:08 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:50266 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXH2KfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r3Fl2Wp+pkL6JGns2dNJV36lTGwNGBf8a/jtja0HffFwCo/FK1Xvvh2L1jljKkHbBET9L/H/xaOw35tZtfJxNF1sPHdp/0O2SRrWr70dqkbIBR2trflrh3GIeQT1OXd6IrD6Fhc1jrLIrs8tOKjXVbjEeBdaeGZSDCDqHjpLnGs=
Message-ID: <4af2d03a0708290335x1a9aa38o566e9d416505f280@mail.gmail.com>
Date: Wed, 29 Aug 2007 08:35:05 -0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1188381582.19891.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7515194658758617@pripojeni.net>
	 <1188381582.19891.6.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-08-28 at 12:00 -0400, Jiri Slaby wrote:
>
> > The files are available only under GPLv2 since now.
>
> Since the BSD people are already getting upset about (for various
> reasons among which seem to be a clear non-understanding) I'd suggest
> changing it to:

yes, please. Can somebody do it, I'm away from my box.

> + * Parts of this file were originally licenced under the BSD licence:
> + *
> >  * Permission to use, copy, modify, and distribute this software for any
> >  * purpose with or without fee is hereby granted, provided that the above
> >  * copyright notice and this permission notice appear in all copies.
> >  *
> >  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
> WARRANTIES
> >  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> >  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> >  * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> >  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> >  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> >  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + *
> + * Further changes to this file since the moment this notice was extended
> + * are now distributed under the terms of the GPL version two as published
> + * by the Free Software Foundation <yaddaya>
>
> johannes
>
