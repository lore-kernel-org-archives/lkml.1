Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXEUUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXEUUou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXEUUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:44:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51862 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbXEUUol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:44:41 -0400
Date: Mon, 21 May 2007 13:33:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, guilherme@centralinf.com.br,
       johnstul@us.ibm.com
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
Message-ID: <20070521203359.GK3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191740.534306000@sous-sol.org> <1179777535.12708.37.camel@chaos> <1179779147.12708.47.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179779147.12708.47.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> What happened to the maxcpus=1 hard lock prevention patch ?

i placed it in the queue for .3.  (primarily due to timing and since it
hadn't hit upstream yet).
