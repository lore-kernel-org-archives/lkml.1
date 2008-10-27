Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbYJ0WsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbYJ0WsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJ0Wr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:47:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33224
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYJ0Wr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:47:59 -0400
Date: Mon, 27 Oct 2008 15:47:36 -0700 (PDT)
Message-Id: <20081027.154736.178482850.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3] printk: add %pM format specifier for MAC
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225137542.5396.10.camel@brick>
References: <1225124904.5440.1.camel@brick>
	<20081027.123805.134354592.davem@davemloft.net>
	<1225137542.5396.10.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 27 Oct 2008 12:59:02 -0700

> Add format specifiers for printing out six colon-separated bytes:
> 
> MAC addresses (%pM):
> xx:xx:xx:xx:xx:xx
> 
> %#pM is also supported and omits the colon separators.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied, thanks.
