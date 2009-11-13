Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZKMKtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZKMKtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZKMKtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:49:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51239 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756040AbZKMKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:49:05 -0500
Date: Fri, 13 Nov 2009 10:50:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113105039.6d438101@lxorguk.ukuu.org.uk>
In-Reply-To: <20091112121805.GF1394@ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
	<20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
	<4AF886D4.1080108@zytor.com>
	<20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
	<20091112121805.GF1394@ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Interesting...geode gx being buggy? I know pentium was famous for the
> fdiv bug, but never heard of geode gx problems...

Depends which one - the older ones were very solid. The very first (5510)
had some interesting bugs but they were fairly soon stomped.

Alan
