Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZLTD3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZLTD3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 22:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZLTD3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 22:29:13 -0500
Received: from mail.anarazel.de ([217.115.131.40]:51419 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZLTD3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 22:29:12 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 22:29:12 EST
From: Andres Freund <andres@anarazel.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: x264 benchmarks BFS vs CFS
Date: Sun, 20 Dec 2009 04:22:17 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-andres-00908-g6ec22f9; KDE/4.3.80; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       "Jason Garrett-Glaser" <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1261042383.14314.0.camel@localhost> <1261195412.8240.153.camel@marge.simson.net> <1261244163.14314.62.camel@localhost>
In-Reply-To: <1261244163.14314.62.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200422.18314.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 December 2009 18:36:03 Kasper Sandberg wrote:
> Try this on a dualcore or quadcore system, or ofcourse just set the<
> niceness accordingly...
Oh well. This is getting too much for a normally very silent and flame fearing 
reader. Didnt *you* just tell others to shut up about using any tunables for 
any application? And that you dont need any tunables for BFS?

Andres
