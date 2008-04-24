Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbYDXAsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbYDXAsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYDXAsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:48:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:48426 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYDXAsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:48:32 -0400
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <480E4FA1.5020508@garzik.org>
	<20080422.150559.115368150.davem@davemloft.net>
	<m34p9smrmp.fsf@maximus.localdomain>
	<20080423.154953.161012169.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 02:48:29 +0200
In-Reply-To: <20080423.154953.161012169.davem@davemloft.net> (David Miller's message of "Wed\, 23 Apr 2008 15\:49\:53 -0700 \(PDT\)")
Message-ID: <m3iqy8f57m.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> No, it was added as an optimization since the private
> area was allocated together with the struct netdev, and
> thus at a constant offset computable a compile time.

That's essentially what I meant. And it has changed, call it whatever
you wish.
-- 
Krzysztof Halasa
