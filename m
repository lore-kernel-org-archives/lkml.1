Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYHTTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYHTTP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYHTTPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:15:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36594 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754086AbYHTTPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:15:11 -0400
Date: Wed, 20 Aug 2008 19:55:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: peter_e@gmx.net, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Pierre Peiffer <peifferp@gmail.com>, containers@lists.osdl.org
Subject: Re: [Bugme-new] [Bug 11381] New: default shmmax
Message-ID: <20080820195509.00994d51@lxorguk.ukuu.org.uk>
In-Reply-To: <20080820120043.e6e7e436.akpm@linux-foundation.org>
References: <bug-11381-10286@http.bugzilla.kernel.org/>
	<20080820120043.e6e7e436.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be useful to get distro input on this.  Do they override the
> kernel default at boot time?  If so, what do they do?

Red Hat provide a sysctl tuning config file and I believe things like the
Oracle install docs cover this.

There is btw no earthly reason why a postgres package can't include a
tool to do this or postgres can't check and update it as part of its
own set up and config file options


Alan
