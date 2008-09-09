Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYIIDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYIIDIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYIIDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:08:14 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13798 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYIIDIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:08:13 -0400
Subject: Re: [GIT]: Networking
From: Alex Williamson <alex.williamson@hp.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: David Miller <davem@davemloft.net>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, j@w1.fi
In-Reply-To: <48C5E2FC.4090304@atheros.com>
References: <20080827.164649.87042354.davem@davemloft.net>
	 <1220627292.7260.3.camel@2710p.home>  <48C5E2FC.4090304@atheros.com>
Content-Type: text/plain
Organization: HP OSLO R&D
Date: Mon, 08 Sep 2008 21:08:08 -0600
Message-Id: <1220929688.7265.4.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 05:44 +0300, Jouni Malinen wrote:
> 
> What exactly does "breaks wireless" mean here?

NetworkManager can see access points, but doesn't get much further than
that.  From an end user perspective, similar to how it behaved in
2.6.26, before Dave's wext compat fixes.

Alex


