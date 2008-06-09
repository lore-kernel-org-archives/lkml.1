Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYFINjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYFINjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYFINjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:39:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44067 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYFINjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:39:12 -0400
Date: Mon, 9 Jun 2008 16:38:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
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
Message-ID: <20080609133819.GC20194@cs181133002.pp.htv.fi>
References: <20080607010215.358296706@sous-sol.org> <20080607010545.198839305@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080607010545.198839305@sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have reports from two different people running into problems that 
are exposed by this patch.

Although it's unclear what's actually going wrong this patch is IMHO 
not -stable fodder until that's sorted out.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

