Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZC0IuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZC0IuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZC0IuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:50:05 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:56901 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZC0IuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:50:04 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 04:50:04 EDT
Date: Fri, 27 Mar 2009 09:39:11 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: Resume after hibernation regression in 2.6.29
Message-ID: <20090327083911.GA3456@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	"Tvrtko A. Ursulin" <tvrtko@ursulin.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
	linux-pm@lists.linux-foundation.org,
	kernel list <linux-kernel@vger.kernel.org>,
	Ayaz Abdulla <aabdulla@nvidia.com>
References: <200903261920.32173.tvrtko@ursulin.net> <20090326211406.GC29836@elf.ucw.cz> <200903262235.29576.rjw@sisk.pl> <200903262201.03931.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903262201.03931.tvrtko@ursulin.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> Not a lot activity in forcedeth.c from 2.6.28 to 2.6.29 so I will CC two guys 
> who commited changes in that period. Ayaz, Tobias, forcedeth does not seem to 
> come up after hibernation well for me. Actual hardware is:
> 
> 00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)

Unfortunately, after moving to a different appartement last weekend,
my nforce mainboard is now about 650Km from where I am and will stay
there for the next months...

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
