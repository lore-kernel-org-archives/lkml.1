Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXCSSAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXCSSAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXCSSAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:00:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34180 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030427AbXCSSAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:00:23 -0400
Date: Mon, 19 Mar 2007 19:03:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, davem@davemloft.net,
       netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #2]
Message-ID: <20070319190306.44f9a2e5@lxorguk.ukuu.org.uk>
In-Reply-To: <25752.1174318898@redhat.com>
References: <20070319152959.46a81e57@lxorguk.ukuu.org.uk>
	<20070319130428.4b645207@lxorguk.ukuu.org.uk>
	<20070318142315.6f881ec8@lxorguk.ukuu.org.uk>
	<20070316153408.3a9a244a@lxorguk.ukuu.org.uk>
	<20070316151305.04cbc352@lxorguk.ukuu.org.uk>
	<20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
	<25571.1174054993@redhat.com>
	<26525.1174058071@redhat.com>
	<20070316171141.7a4de504@lxorguk.ukuu.org.uk>
	<076F1B35-BE08-41B4-8294-581EDAFF4ACC@mac.com>
	<2578.1174305403@redhat.com>
	<3728.1174309154@redhat.com>
	<25752.1174318898@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> No, it's not.  SOCK_DGRAM is an unreliable, unidirectional datagram passing
> service.

Thats funny UDP receives and sends packets.


