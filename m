Return-Path: <linux-kernel-owner+w=401wt.eu-S934871AbXEUU0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871AbXEUU0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761365AbXEUUZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:25:54 -0400
Received: from www.osadl.org ([213.239.205.134]:50182 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760998AbXEUUZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:25:53 -0400
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
In-Reply-To: <1179777535.12708.37.camel@chaos>
References: <20070521191612.800400000@sous-sol.org>
	 <20070521191740.534306000@sous-sol.org>  <1179777535.12708.37.camel@chaos>
Content-Type: text/plain
Date: Mon, 21 May 2007 22:25:46 +0200
Message-Id: <1179779147.12708.47.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 21:58 +0200, Thomas Gleixner wrote:

> Dunno. There is another one missing:

What happened to the maxcpus=1 hard lock prevention patch ?

	tglx


