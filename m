Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbXERKGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbXERKGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXERKGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:06:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbXERKGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:06:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464D7005.6030504@sw.ru>
References: <464D7005.6030504@sw.ru> <464D6E87.7060605@sw.ru>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chas@cmf.nrl.navy.mil, axboe@kernel.dk, herbert@gondor.apana.org.au,
       dmitry.torokhov@gmail.com, kkeil@suse.de,
       David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       viro@zeniv.linux.org.uk, devel@openvz.org
Subject: Re: [PATCH 1/15] The helper functions itselves
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 18 May 2007 10:59:08 +0100
Message-ID: <7990.1179482348@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> wrote:

> Many places in kernel use seq_file API to iterate over a regular
> list_head. The code for such iteration is identical in all the
> places, so it's worth introducing a common helpers.

And the documentation for this?

David
