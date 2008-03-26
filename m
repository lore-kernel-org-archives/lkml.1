Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYCZXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYCZXFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYCZXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:05:18 -0400
Received: from khc.piap.pl ([195.187.100.11]:40500 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbYCZXFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:05:17 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3tzj92xq6.fsf@maximus.localdomain>
	<m33aqedg0a.fsf@maximus.localdomain> <47E91256.3010000@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 27 Mar 2008 00:05:15 +0100
In-Reply-To: <47E91256.3010000@garzik.org> (Jeff Garzik's message of "Tue\, 25 Mar 2008 10\:55\:18 -0400")
Message-ID: <m3iqz9jdck.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> So quite honestly a CONFIG_BROKEN patch might indeed be more
> appropriate since generic HDLC works with Frame Relay at least...

Actually my question was intended for Andrew as he has already
queued the PPP patch - I probably should have rearranged To/Cc:
headers, sorry about that.

The question still stands: I guess it's fair enough to have either
patch in 2.6.25 (new PPP or "BROKEN" in Kconfig) but I think we
shouldn't leave it as is.
-- 
Krzysztof Halasa
