Return-Path: <linux-kernel-owner+w=401wt.eu-S1031228AbXHMT63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031228AbXHMT63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943207AbXHMT4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:56:53 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:10179 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965836AbXHMT4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yd7i+uF/8dZ+SQ1u2DfY700xhRWKVvwWwRYJQJNAaiffFKWcu+2sde+EqDAYxpyhLaa9QlztxOQe+Ab8LFZp1zI1ppihw7yss6xOlHitx3t46edsL/nQXwvs1I9kRRAQ8e0Kbnh7yCxQxT3u1m1zmRF9XXSMxL5inG8642s9NdA=
Message-ID: <8bd0f97a0708131256r447890c8q4848b333cf23d4f0@mail.gmail.com>
Date: Mon, 13 Aug 2007 15:56:49 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: Bad addresses in MAINTAINERS
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1187032769.10249.270.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187032024.10249.266.camel@localhost>
	 <8bd0f97a0708131210i13d2eeefp8055d444a9d2ce7a@mail.gmail.com>
	 <1187032769.10249.270.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-08-13 at 15:10 -0400, Mike Frysinger wrote:
> > On 8/13/07, Joe Perches <joe@perches.com> wrote:
> > > But if anyone has a new email address and still wants
> > > to be in the maintainers file, please send.
> > >
> > > BLACKFIN ARCHITECTURE
> > > P:      Aubrey Li
> > > M:      aubrey.li@analog.com
> > > P:      Jerry Zeng
> > > M:      jerry.zeng@analog.com
> >
> > we know these guys needed to be removed as they've recently left ADI,
> > we just havent pushed to mainline
>
> Maybe you can have a "blackfin_arch@analog.com" list as maintainers?

we have a mailing list already ... could just drop the general list of
people for Blackfin and keep specific e-mails for specific drivers
-mike
