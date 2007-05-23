Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbXEWHTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbXEWHTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXEWHTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:19:32 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:59631 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXEWHTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:19:31 -0400
Date: Wed, 23 May 2007 09:19:03 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Romano Giannetti <romano.giannetti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/69] -stable review
Message-ID: <20070523091903.0ba29bc1@localhost>
In-Reply-To: <1179904140.7043.10.camel@localhost>
References: <20070521191612.800400000@sous-sol.org>
	<4652070D.3090509@redhat.com>
	<alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	<20070521212522.GL3429@sequoia.sous-sol.org>
	<1179870110.16656.2.camel@localhost>
	<alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	<1179904140.7043.10.camel@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 09:09:00 +0200
Romano Giannetti <romano.giannetti@gmail.com> wrote:

> Will try to reboot with clocksource=acpi_pm, althoughI think that this
> is the one I'm using. 

you can see that with:

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

-- 
	Paolo Ornati
	Linux 2.6.22-rc2-gd2579053 on x86_64
