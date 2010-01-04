Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820Ab0ADSmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0ADSmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0ADSmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:42:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44881
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808Ab0ADSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:42:45 -0500
Date: Mon, 04 Jan 2010 10:42:49 -0800 (PST)
Message-Id: <20100104.104249.89137409.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, tom@opengridcomputing.com
Subject: Re: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F824@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F6BA@mi8nycmail19.Mi8.com>
	<20100103.222406.219629437.davem@davemloft.net>
	<BD79186B4FD85F4B8E60E381CAEE19090200F824@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 4 Jan 2010 12:39:12 -0500

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Tom Tucker <tom@opengridcomputing.com>
> 
> ---
> 
> David,
> 
> Can you please try the following patch to see if the 'fuzz' issue
> is still present.  I think my email client was stripping the last
> empty line from the patch.  Thanks.

Yep, I think it is, this patch has the same problem all of
your previous ones did.
