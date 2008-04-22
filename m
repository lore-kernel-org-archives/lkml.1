Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbYDVWDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbYDVWDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbYDVWC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:02:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbYDVWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:02:57 -0400
Date: Tue, 22 Apr 2008 15:02:59 -0700 (PDT)
Message-Id: <20080422.150259.205494753.davem@davemloft.net>
To: paulkf@microgate.com
Cc: khc@pm.waw.pl, jchapman@katalix.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <480E5CB3.2080003@microgate.com>
References: <480CEB7D.8070702@katalix.com>
	<m33apdyajf.fsf@maximus.localdomain>
	<480E5CB3.2080003@microgate.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fulghum <paulkf@microgate.com>
Date: Tue, 22 Apr 2008 15:46:27 -0600

> The response is usually "support the simpler generic
> HDLC PPP way of doing things or we will go elsewhere".

Users say this to strong-hand developers, it's not something you
should ever take very seriously.  And even if Linux may simply not be
for them, well that's fine too, and implementing something as obscure
as HDLC PPP one way or the other is not going to change that.

I mean, be realistic here.

Are we going to have three copies of code implementing the same
thing because some HDLC PPP users threatened to defect?  That's
simply rediculious.
