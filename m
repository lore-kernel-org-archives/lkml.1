Return-Path: <linux-kernel-owner+w=401wt.eu-S1423439AbXBHVeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423439AbXBHVeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423437AbXBHVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:34:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42725
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423433AbXBHVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:34:44 -0500
Date: Thu, 08 Feb 2007 13:34:43 -0800 (PST)
Message-Id: <20070208.133443.30185813.davem@davemloft.net>
To: ahendry@tusc.com.au
Cc: linux-x25@vger.kernel.org, eis@baty.hanse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] X.25: Adds /proc/sys/net/x25/x25_forward to
 control forwarding.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1170890071.5189.40.camel@localhost>
References: <1170890071.5189.40.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ahendry <ahendry@tusc.com.au>
Date: Thu, 08 Feb 2007 10:14:31 +1100

> echo "1" > /proc/sys/net/x25/x25_forward 
> To turn on x25_forwarding, defaults to off
> Requires the previous patch.
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Applied.
