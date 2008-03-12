Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbYCLIsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbYCLIsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYCLIsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:48:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41766 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCLIsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:48:36 -0400
Date: Wed, 12 Mar 2008 09:48:49 +0100
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080312094849.3c950bbf@bull.net>
In-Reply-To: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Fred,

On Wed, 12 Mar 2008 00:32:14 +0100 "Fred ." <eldmannen@gmail.com> wrote:

> I (and many others) have a problem.

  So did I :(

> 
> I am using Ubuntu 8.04 "Hardy Heron" (alpha).
> xorg  1:7.3+10ubuntu6
> Linux ubuntu 2.6.24-12-generic #1 SMP Mon Mar 10 15:32:00 UTC 2008
> i686 GNU/Linux
> 
> MSI P35 Neo motherboard with a HP USB keyboard.
> 
> Sometimes the keys get "stuck" and it keeps on repeating the button
> all the time.
> It often happen when I play games, that it repeats one of the arrow keys.
> 
> Now this is a problem that lots of people have experienced.
> I've experienced it with other kernels too.
> 
> https://bugs.launchpad.net/ubuntu/+source/xorg/+bug/194214
> 
> It is a very annoying bug, that happens to many users.
> Restarting Xorg solves the problem.
> 
> Someone said this was a problem with dynticks, but I don't know.

  I had the same problem back in the 2.6.16 to 2.6.20 days (no dynticks).
The only solution I found was to get rid of gnome. Since then I've been
happily running with xfce.

> 
> Does anyone know what is causing this problem, and how to fix it?

  Yep, try to get rid of gnome, if you don't see the problem anymore then
complain to the gnome developers.

  Sebastien.
