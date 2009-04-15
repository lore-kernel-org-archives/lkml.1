Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZDOKqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZDOKqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbZDOKqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:46:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbZDOKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:46:00 -0400
Date: Wed, 15 Apr 2009 03:45:51 -0700 (PDT)
Message-Id: <20090415.034551.214493254.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: kaber@trash.net, m.kozlowski@tuxland.pl, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: panic on rmmod of nf_conntrack_irc
From: David Miller <davem@davemloft.net>
In-Reply-To: <49E5BA13.7000501@cosmosbay.com>
References: <49E47C2D.1050508@cosmosbay.com>
	<49E5B66D.30602@trash.net>
	<49E5BA13.7000501@cosmosbay.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 15 Apr 2009 12:42:27 +0200

> Sure, but its a cleanup (and was an RFC to show my point)
> so should wait a litle bit until David opens his -next tree (for 2.6.31)

The net-next-2.6 tree is open for business since 2.6.30-rc1 :-)

> Please just submit your patch for 2.6.30 ?

I'll let Patrick voice his opinion on this, I don't care either
way.
