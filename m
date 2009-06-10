Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZFJEAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZFJEAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZFJEAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:00:41 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:42888 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbZFJEAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:00:40 -0400
Date: Wed, 10 Jun 2009 00:00:35 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Tobias_Mueller@twam.info
Cc: Andrew Morton <akpm@linux-foundation.org>, jordan@cosmicpenguin.net,
       david-b@pacbell.net, gardner.ben@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-ID: <20090610000035.62e459ae@mycelium.queued.net>
In-Reply-To: <17be05570906090527l5861a79dq2ca8e6cf0ba084fe@mail.gmail.com>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	<20090526151621.a7446c60.akpm@linux-foundation.org>
	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
	<20090601165457.a1cc1025.akpm@linux-foundation.org>
	<20090601200821.62b04e43@mycelium.queued.net>
	<4A24965C.2020901@cosmicpenguin.net>
	<17be05570906020114k7f2a3096h48335d509951cf90@mail.gmail.com>
	<20090602133312.68158cd5.akpm@linux-foundation.org>
	<17be05570906090527l5861a79dq2ca8e6cf0ba084fe@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 14:27:30 +0200
Tobias Müller <Tobias_Mueller@twam.info> wrote:

> >> So maybe we should decide whether we take Andre's or my approach
> >> and then adjust it.
> >>
> >
> > I think I'll drop gpio-amd-cs5535-cs5536-gpio-driver.patch while you
> > guys sort all this out, please.
> 
> So, how to carry on with this? Shall I adapt Andre's version to mine
> or will Andre take care of this version?
> 
> A comment from Andre would be fine.


My preference would be for you to base your work on the patches that
I'm about to (re)submit.  I now actually have time to get these through
the queue.
