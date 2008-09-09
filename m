Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYIIERA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYIIERA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYIIEPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:15:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45623
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbYIIEPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:15:54 -0400
Date: Mon, 08 Sep 2008 21:15:48 -0700 (PDT)
Message-Id: <20080908.211548.216826057.davem@davemloft.net>
To: j@w1.fi
Cc: jouni.malinen@atheros.com, alex.williamson@hp.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080909040525.GA26151@hostap.isc.org>
References: <20080909025525.GB25148@hostap.isc.org>
	<20080908.204323.04156464.davem@davemloft.net>
	<20080909040525.GA26151@hostap.isc.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Malinen <j@w1.fi>
Date: Mon, 8 Sep 2008 21:05:25 -0700

> Would people be fine with extending wireless_send_event() with new
> event types that use fixed sized fields or is someone going to be
> interesting in providing a better replacement for this
> functionality?

I thought this was the idea behind nl80211?  To be a new netlink
interface for wireless, one that actually is designed correctly
from the start and thus can avoid all of these problems.

