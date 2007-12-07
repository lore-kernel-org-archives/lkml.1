Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXLGDlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXLGDlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXLGDlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:41:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48615
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbXLGDlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:41:31 -0500
Date: Thu, 06 Dec 2007 19:41:31 -0800 (PST)
Message-Id: <20071206.194131.79623068.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: andi@firstfloor.org, renzo@cs.unibo.it, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47585D66.3000404@nortel.com>
References: <20071206053016.GA1464@cs.unibo.it>
	<20071206163538.GC20595@one.firstfloor.org>
	<47585D66.3000404@nortel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Thu, 06 Dec 2007 14:36:54 -0600

> One problem we ran into was that there are only 32 multicast groups per 
> netlink protocol family.

I'm pretty sure we've removed this limitation.
