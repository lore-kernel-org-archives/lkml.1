Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZKHUlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZKHUlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbZKHUlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:41:02 -0500
Received: from khc.piap.pl ([195.187.100.11]:50035 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbZKHUlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:41:01 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
	<20091108173708.GF1372@ucw.cz>
	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
	<20091108181016.GB32364@elf.ucw.cz>
	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
Date: Sun, 08 Nov 2009 21:41:04 +0100
In-Reply-To: <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
	(Sven-Haegar Koch's message of "Sun, 8 Nov 2009 20:29:55 +0100 (CET)")
Message-ID: <m3tyx4agwv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sven-Haegar Koch <haegar@sdinet.de> writes:

> But no standard distribution will be made available in a geode special 
> version - not enough machines in the marekt. So I think it is better to 
> be able to use the i686 specific things they already support, like 
> libc6-686 from debian for example.

If it's only libc issue (and maybe of a couple of other packages like
gzip and bzip2), then I think it would be preferable for distributions
to provide a version optimized for Geode, without kernel hacks.
Though I guess the above is not actually the case, is it?
-- 
Krzysztof Halasa
