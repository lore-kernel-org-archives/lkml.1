Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZDNOvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZDNOvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZDNOu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:50:57 -0400
Received: from khc.piap.pl ([195.187.100.11]:39249 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZDNOu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:50:56 -0400
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, martin@valinux.com,
       gareth@valinux.com, airlied@linux.ie, dri-devel@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] radeon_cp: use request_firmware
References: <1239640067.3237.4.camel@ht.satnam>
	<1239647163.18110.150.camel@deadeye.i.decadent.org.uk>
	<1239684881.3033.11.camel@ht.satnam>
	<20090414142618.GY3051@decadent.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 14 Apr 2009 16:50:51 +0200
In-Reply-To: <20090414142618.GY3051@decadent.org.uk> (Ben Hutchings's message of "Tue\, 14 Apr 2009 15\:26\:18 +0100")
Message-ID: <m3bpqzuw50.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> I don't copy Signed-off-by if I make significant changes as the original
> author should not be held responsible for any errors.  I'll be happy to
> ask for your S-o-b before submitting a patch based on your work in future.

I think we should never include the original SOB if there was _any_
change. SOB is not credits, it's a signature. If someone takes my patch
and changes it, I want my SOB line removed unless I re-sign the modified
patch.

We may invent some other Based-on-patch-by: etc. tag if really
necessary, but the signature is a different thing.
-- 
Krzysztof Halasa
