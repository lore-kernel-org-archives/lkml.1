Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbYDVWvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbYDVWvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYDVWvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:51:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47472
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbYDVWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:51:32 -0400
Date: Tue, 22 Apr 2008 15:51:33 -0700 (PDT)
Message-Id: <20080422.155133.19052713.davem@davemloft.net>
To: jchapman@katalix.com
Cc: jeff@garzik.org, paulkf@microgate.com, khc@pm.waw.pl,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <480E6563.9020109@katalix.com>
References: <480E5CB3.2080003@microgate.com>
	<480E4FA1.5020508@garzik.org>
	<480E6563.9020109@katalix.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Tue, 22 Apr 2008 23:23:31 +0100

> I guess what caught my eye is a PPP control protocol implementation 
> being in the kernel. I'd seen syncppp before but I assumed it was there 
> for legacy reasons. A while ago there seemed to be strong desire to move 
> control protocols such as bridge spanning tree into userspace. Is this 
> no longer the case?

It is still the case, believe me :-)
