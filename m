Return-Path: <linux-kernel-owner+w=401wt.eu-S934604AbXEUT7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934604AbXEUT7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXEUToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:44:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935082AbXEUToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:44:04 -0400
Date: Mon, 21 May 2007 12:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/69] -stable review
Message-Id: <20070521123148.a3dad5f2.akpm@linux-foundation.org>
In-Reply-To: <20070521191612.800400000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 12:16:12 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> This is the start of the stable review cycle for the 2.6.21.2 release.

Gee a lot of these are fixing recently-added regressions :(

Did we fix oprofile on x86_64 yet?  If not, I'd suggest we should
hold off 2.6.21.2 until we have done so.

I assume ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/oprofile-allocation
is what we want.
