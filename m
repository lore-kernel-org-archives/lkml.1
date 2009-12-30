Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZL3RQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZL3RQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZL3RQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:16:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51405
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbZL3RQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:16:13 -0500
Date: Wed, 30 Dec 2009 09:16:16 -0800 (PST)
Message-Id: <20091230.091616.59661674.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/catc.c: use %pM to shown MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F4CB@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F4CB@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 28 Dec 2009 18:22:13 -0500

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
