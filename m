Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXIBALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXIBALW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932475AbXIBALL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:11:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:50144 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbXIBALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+g12DAmTdSlAmt4wuEFv3tgo9zrXpjV8y1UBFra5LPFPAK8TSbmeXU4vLOqdYrDtlYQ96FksLZglbWzDgt+VXSJCgLghHkHg9hZ6iUYz7JqFMZ36Mni+HwlpJmZVnW6Bc1u/tAP635/G3HnWJrdTvtCJioBzis+vxEJDWcSvLk=
Message-ID: <f34ca13c0709011711n8521bc2k58a13f0fd4e98403@mail.gmail.com>
Date: Sat, 1 Sep 2007 20:11:07 -0400
From: "Constantine A. Murenin" <mureninc@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Cc: "Adrian Bunk" <bunk@kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <43e72e890709011648k5caffb7fn1051e1f5d5f27c9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	 <46D99FB7.6030505@garzik.org>
	 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	 <20070901205457.GK9260@stusta.de>
	 <f34ca13c0709011427u7a9cc97bp75c035afed3e5a63@mail.gmail.com>
	 <20070901215225.GM9260@stusta.de>
	 <f34ca13c0709011629g1f16508cic7c31c3d20a57dae@mail.gmail.com>
	 <43e72e890709011648k5caffb7fn1051e1f5d5f27c9b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I urge developers to not bait into this and just leave this alone.
> Those involved know what they are doing and have a strong team of
> attorneys watching their backs. Any *necessary* discussions are be
> done privately.

Err...

I don't understand why you need a lawyer to interpret this document:

/*     $OpenBSD: ar5210.c,v 1.39 2007/04/10 17:47:55 miod Exp $        */

/*
 * Copyright (c) 2004, 2005, 2006, 2007 Reyk Floeter <reyk@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

If you want to add more code to it, and your contribution is
significant, simply add you name next to Reyk's. Where's the problem?

I don't know how licensing could be any simpler than this. Please,
notice, that there are no additional documents (other than the
copyright law) to read here -- _this is the complete licence_! (And
you have to read the copyright law even if you use the GNU GPL.)

C.
