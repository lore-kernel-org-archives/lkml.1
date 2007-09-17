Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbXIQGtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbXIQGtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 02:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXIQGtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 02:49:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbXIQGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 02:49:05 -0400
Date: Sun, 16 Sep 2007 23:48:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@ubuntu.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Greg KH <greg@kroah.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Michael Wu <flamingice@sourmilk.net>,
       Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Message-Id: <20070916234821.445c45fa.akpm@linux-foundation.org>
In-Reply-To: <20070917034554.GO17546@outflux.net>
References: <20070912064134.GO7910@outflux.net>
	<46E7C91D.3070001@garzik.org>
	<b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	<20070912215356.GC23294@kroah.com>
	<20070913004937.GM8183@outflux.net>
	<a781481a0709161822m3b1c09f8l33e70579707e9023@mail.gmail.com>
	<20070917034554.GO17546@outflux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 20:45:54 -0700 Kees Cook <kees@ubuntu.com> wrote:

> The cleanups you suggested, who should I send those to?  Or will you (or
> Sam?) make them directly to the kbuild.git tree?  (I've never poked at
> this part of the kernel source before... I'm unclear on the processes
> surrounding it maintainership.)

If they hit my inbox they won't get lost..
