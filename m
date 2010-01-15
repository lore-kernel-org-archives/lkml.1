Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0AOJti (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275Ab0AOJtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:49:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44171
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296Ab0AOJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:49:35 -0500
Date: Fri, 15 Jan 2010 01:49:43 -0800 (PST)
Message-Id: <20100115.014943.39860500.davem@davemloft.net>
To: acme@ghostprotocols.net
Cc: roel.kluin@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [NET]: da.s_net not copied but assigned to itself in
 aarp_rcv()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100114210001.GE20221@ghostprotocols.net>
References: <4B4F7F4B.8000302@gmail.com>
	<20100114210001.GE20221@ghostprotocols.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 14 Jan 2010 19:00:01 -0200

> Em Thu, Jan 14, 2010 at 09:32:11PM +0100, Roel Kluin escreveu:
>> da.s_net was not copied but assigned to itself.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Looks right, must be there for ages...
> 
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Applied, please always CC: on networking patches.

Thanks.
