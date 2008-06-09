Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYFIQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYFIQyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYFIQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:54:40 -0400
Received: from sous-sol.org ([216.99.217.87]:37752 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYFIQyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:54:39 -0400
Date: Mon, 9 Jun 2008 09:48:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>, Neil Brown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 01/50] block: do_mounts - accept root=<non-existant
	partition>
Message-ID: <20080609164855.GF30402@sequoia.sous-sol.org>
References: <20080607010215.358296706@sous-sol.org> <20080607010545.198839305@sous-sol.org> <20080609133819.GC20194@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609133819.GC20194@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> We have reports from two different people running into problems that 
> are exposed by this patch.

Thanks, pulled.  We can add back (plus Linus' fix) once everything
is settled.

thanks,
-chris
