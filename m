Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYDXUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYDXUui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYDXUu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:50:27 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:36521 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYDXUu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:50:26 -0400
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3r6cv75xq.fsf@maximus.localdomain>
	<20080424.063006.153647297.davem@davemloft.net>
	<m3mynj74nw.fsf@maximus.localdomain>
	<20080424.065555.30390704.davem@davemloft.net>
	<m3ve27nfpx.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 22:50:24 +0200
In-Reply-To: <m3ve27nfpx.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Thu\, 24 Apr 2008 22\:46\:34 +0200")
Message-ID: <m3r6cvnfjj.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I'm not
> against using generic PPP, it's (AFAICS) clean and *working* and
> *maintained* (and I'm not worried about backward compatibility and
> certainly not about users' visions).

IOW I value correctness over backward compatibility and users'
visions, obviously I try to keep compatibility and meet users'
needs when it actually makes sense.
-- 
Krzysztof Halasa
