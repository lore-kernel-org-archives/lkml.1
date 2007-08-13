Return-Path: <linux-kernel-owner+w=401wt.eu-S974590AbXHMSwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974590AbXHMSwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974449AbXHMSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:41:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:56632 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972932AbXHMSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:41:07 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>
	<200708131933.10125.m.kozlowski@tuxland.pl>
	<1187026955.2688.4.camel@laptopd505.fenrus.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 13 Aug 2007 20:41:03 +0200
In-Reply-To: <1187026955.2688.4.camel@laptopd505.fenrus.org> (Arjan van de Ven's message of "Mon, 13 Aug 2007 10:42:35 -0700")
Message-ID: <m3odhb46rk.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> The maintainer info should be in the source file itself!

Nope, it should be outside of the (downloadable) tarball, because
once someone get a tarball you can't update the data in it.
This is fine WRT source (which is static given a version) but
doesn't work for fast-changing data.
-- 
Krzysztof Halasa
