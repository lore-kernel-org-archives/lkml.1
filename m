Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYLCWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYLCWHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYLCWGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:06:18 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:20972 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYLCWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:06:16 -0500
Message-ID: <493702CC.5030804@msgid.tls.msk.ru>
Date: Thu, 04 Dec 2008 01:06:04 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 000/104] 2.6.27-stable review
References: <20081203194725.GA8950@kroah.com>
In-Reply-To: <20081203194725.GA8950@kroah.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
[]
> And yes, there are a lot of patches here, the big series are:
...
> 	- ext4 bugfixes

I wonder why updates for ext4, which is still marked
"experimental" in kconfig, should go to -stable in
the first place...  Given the number of bugs^Wpatches
in this part of the kernel, and given the amount
of current development in this area.  Just.. curious.

Thanks!

/mjt
