Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbXEUU7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbXEUU7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXEUU6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:58:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbXEUU6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:58:51 -0400
Message-ID: <4652070D.3090509@redhat.com>
Date: Mon, 21 May 2007 16:54:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/69] -stable review
References: <20070521191612.800400000@sous-sol.org>
In-Reply-To: <20070521191612.800400000@sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> This is the start of the stable review cycle for the 2.6.21.2 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 

What happened to:

"Fix ACPI suspend / device suspend ordering problem"
52ade9b3b97fd3bea42842a056fe0786c28d0555


