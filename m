Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYEZOJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYEZOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYEZOJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:09:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60187 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYEZOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:09:13 -0400
Date: Mon, 26 May 2008 16:09:11 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug'
 is passed.
In-Reply-To: <18490.33106.357734.800133@harpo.it.uu.se>
Message-ID: <alpine.LNX.1.10.0805261607090.19084@fbirervta.pbzchgretzou.qr>
References: <1211687267-12962-1-git-send-email-krh@redhat.com> <18490.33106.357734.800133@harpo.it.uu.se>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-26 11:22, Mikael Pettersson wrote:
>=?utf-8?q?Kristian=20H=C3=B8gsberg?= writes:
> > Signed-off-by: Kristian HÃ¸gsberg <krh@redhat.com>
> > ---
> > 
> > Updated to use the standard 'debug' parameter instead of 'noisy'.
> > 
> >  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
> >  1 files changed, 27 insertions(+), 3 deletions(-)
>
>NAK
>
>You still haven't explained why suppressing these
>messages is necessary.

In fact, quite the opposite, http://tinyurl.com/68notu , is worthwhile.
