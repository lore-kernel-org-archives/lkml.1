Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYLDOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYLDOHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYLDOHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:07:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53481 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754710AbYLDOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:07:41 -0500
Date: Thu, 4 Dec 2008 14:07:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Shane McDonald" <mcdonald.shane@gmail.com>
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Message-ID: <20081204140742.1d0d8046@lxorguk.ukuu.org.uk>
In-Reply-To: <b2b2f2320812040601k55ab69a6n5da4d321151f94f@mail.gmail.com>
References: <E1L4UpB-0007ro-1g@localhost>
	<492A8306.9000400@ru.mvista.com>
	<b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
	<20081204100717.32819f1b@lxorguk.ukuu.org.uk>
	<b2b2f2320812040601k55ab69a6n5da4d321151f94f@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008 08:01:49 -0600
"Shane McDonald" <mcdonald.shane@gmail.com> wrote:

> Would it be acceptable to claim that these changes are outside the
> scope of this patch, and code the IT8172 driver to behave in the same
> manner as the other wrong drivers, with a suitable comment indicating
> this fact?

I think so..  and if its moved over to libata it can just be fixed then


Alan
