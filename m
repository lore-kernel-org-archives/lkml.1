Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXCMKY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXCMKY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXCMKY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:24:57 -0400
Received: from smtp14.orange.fr ([193.252.23.69]:23955 "EHLO smtp14.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXCMKY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:24:56 -0400
X-ME-UUID: 20070313102455582.8E285700009D@mwinf1408.orange.fr
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for
	2.6.21-rc3-mm2
From: Xavier Bestel <xavier.bestel@free.fr>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200703132031.39370.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <20070313081805.GA22327@elte.hu> <200703132021.50712.kernel@kolivas.org>
	 <200703132031.39370.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 11:24:47 +0100
Message-Id: <1173781487.9840.10.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 20:31 +1100, Con Kolivas wrote:
> nice on my debian etch seems to choose nice +10 without arguments contrary to 
> a previous discussion that said 4 was the default. However 4 is a good value 
> to use as a base of sorts.

I don't see why. nice uses +10 by default on all linux distro, and even
on Solaris and HP/UX. So I suspect that if Mike just used "nice lame"
instead of "nice +5 lame", he would have got what he wanted.

	Xav


