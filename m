Return-Path: <linux-kernel-owner+w=401wt.eu-S1032223AbXHMTDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032223AbXHMTDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXHMTC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:02:57 -0400
Received: from khc.piap.pl ([195.187.100.11]:39183 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbXHMTCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:02:55 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>
	<200708131933.10125.m.kozlowski@tuxland.pl>
	<1187026955.2688.4.camel@laptopd505.fenrus.org>
	<m3odhb46rk.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 13 Aug 2007 21:02:53 +0200
In-Reply-To: <m3odhb46rk.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Mon, 13 Aug 2007 20:41:03 +0200")
Message-ID: <m3bqdb45r6.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Nope, it should be outside of the (downloadable) tarball, because
> once someone get a tarball you can't update the data in it.
> This is fine WRT source (which is static given a version) but
> doesn't work for fast-changing data.

... OTOH I think this additional info in MAINTAINERS file is better
than the file without it.
-- 
Krzysztof Halasa
