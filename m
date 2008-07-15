Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYGOXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYGOXFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYGOXFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:05:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55383 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYGOXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:05:34 -0400
Message-ID: <487D2D30.1040304@garzik.org>
Date: Tue, 15 Jul 2008 19:05:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       tytso@mit.edu, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>	 <487D1327.7090805@garzik.org>	 <1216157061.26991.41.camel@shinybook.infradead.org>	 <20080715.144720.66126410.davem@davemloft.net> <1216161752.26991.61.camel@shinybook.infradead.org>
In-Reply-To: <1216161752.26991.61.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Until now. The only significant _generic_ change that just went into
> Linus' kernel is the fact that you can now build that firmware _into_
> your kernel, and you can boot qla2xxx without an initrd again.

Yes, that is quite nice...

It will be nice to be able to do the same with modules too :)

	Jeff



