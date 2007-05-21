Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbXEUUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbXEUUhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXEUUhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:37:02 -0400
Received: from www.osadl.org ([213.239.205.134]:56110 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755127AbXEUUhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:37:00 -0400
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, guilherme@centralinf.com.br,
       johnstul@us.ibm.com
In-Reply-To: <20070521203359.GK3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
	 <20070521191740.534306000@sous-sol.org> <1179777535.12708.37.camel@chaos>
	 <1179779147.12708.47.camel@chaos>
	 <20070521203359.GK3429@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 22:36:55 +0200
Message-Id: <1179779815.12708.51.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 13:33 -0700, Chris Wright wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > What happened to the maxcpus=1 hard lock prevention patch ?
> 
> i placed it in the queue for .3.  (primarily due to timing and since it
> hadn't hit upstream yet).

Fair enough.

	tglx


