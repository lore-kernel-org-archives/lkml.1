Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXCaCcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXCaCcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCaCcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:32:04 -0400
Received: from stinky.trash.net ([213.144.137.162]:52083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387AbXCaCcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:32:03 -0400
Message-ID: <460DC818.4060003@trash.net>
Date: Sat, 31 Mar 2007 04:31:52 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to
 advance through scatterlist
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com> <460DBC4C.1060602@trash.net> <20070331021437.GA31298@gondor.apana.org.au>
In-Reply-To: <20070331021437.GA31298@gondor.apana.org.au>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Indeed.  That patch was buggy.  Sorry for not catching this earlier.
> 
> This should fix the problem.


Works fine, thanks Herbert.
