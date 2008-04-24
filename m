Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYDXN4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYDXN4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYDXNz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:55:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55964
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbYDXNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:55:56 -0400
Date: Thu, 24 Apr 2008 06:55:55 -0700 (PDT)
Message-Id: <20080424.065555.30390704.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, paulkf@microgate.com, jchapman@katalix.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3mynj74nw.fsf@maximus.localdomain>
References: <m3r6cv75xq.fsf@maximus.localdomain>
	<20080424.063006.153647297.davem@davemloft.net>
	<m3mynj74nw.fsf@maximus.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Apr 2008 15:39:47 +0200

> Though we will have to abandon syncppp use anyway, at least for
> generic HDLC (I don't care much about the old ISA drivers).

That, I still don't understand.

I would rather see you add small extensions to syncppp to
provide for HDLC's needs, rather than reimplement it.
