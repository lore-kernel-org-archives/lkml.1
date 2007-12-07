Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXLGKDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXLGKDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXLGKDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:03:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXLGKDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:03:25 -0500
Date: Fri, 7 Dec 2007 11:03:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: cfriesen@nortel.com, andi@firstfloor.org, renzo@cs.unibo.it,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071207100322.GM20595@one.firstfloor.org>
References: <47585D66.3000404@nortel.com> <20071206.194131.79623068.davem@davemloft.net> <4758CA53.7000407@nortel.com> <20071206.224005.42816421.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206.224005.42816421.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stop making excuses, with minor adjustments we have the facilities to
> meet your needs.  There is no need for yet-another-protocol to do what

I suspect they would be better of just using IP multicast. But the localhost 
latency penalty vs Unix Chris was talking about probably needs to be investigated.

-Andi
