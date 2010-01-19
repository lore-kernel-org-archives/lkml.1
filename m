Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0ASNUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0ASNUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590Ab0ASNUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:20:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47713 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751118Ab0ASNUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:20:47 -0500
Date: Tue, 19 Jan 2010 13:21:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100119132138.473cf073@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119120712.GM14345@redhat.com>
References: <20100118141938.GI30698@redhat.com>
	<84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	<20100118170816.GA22111@redhat.com>
	<84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	<20100118181942.GD22111@redhat.com>
	<20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	<20100119071734.GG14345@redhat.com>
	<84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	<20100119075205.GI14345@redhat.com>
	<20100119115442.131efa78@lxorguk.ukuu.org.uk>
	<20100119120712.GM14345@redhat.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And you want millions of users to have kernels with weird extra functions
> > whole sole value is one test environment you wish to run
> > 
> We are talking about 4 lines of code that other people find useful too
> and they commented in this thread. This wouldn't be the first kernel
> feature not used by millions of people.

It wouldn't be the first completely dumb mistake in the kernel either,
but one dumb mistake doesn't argue for including others 
