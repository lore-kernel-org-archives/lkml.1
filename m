Return-Path: <linux-kernel-owner+w=401wt.eu-S1423443AbXBHVfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423443AbXBHVfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423438AbXBHVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:35:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42730
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423436AbXBHVfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:35:43 -0500
Date: Thu, 08 Feb 2007 13:35:42 -0800 (PST)
Message-Id: <20070208.133542.122617945.davem@davemloft.net>
To: ahendry@tusc.com.au
Cc: linux-x25@vger.kernel.org, eis@baty.hanse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] X.25: Adds /proc/net/x25/forward to view active
 forwarded calls.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1170890079.5189.41.camel@localhost>
References: <1170890079.5189.41.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ahendry <ahendry@tusc.com.au>
Date: Thu, 08 Feb 2007 10:14:39 +1100

> View the active forwarded calls
> cat /proc/net/x25/forward
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Also applied, thank you.
