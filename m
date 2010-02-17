Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0BQVm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:42:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57258
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab0BQVmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:42:25 -0500
Date: Wed, 17 Feb 2010 13:42:41 -0800 (PST)
Message-Id: <20100217.134241.12902816.davem@davemloft.net>
To: steve@digidescorp.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ll_temac: Fix MAC address configuration from userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266429307-11765-1-git-send-email-steve@digidescorp.com>
References: <1266429307-11765-1-git-send-email-steve@digidescorp.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven J. Magnani" <steve@digidescorp.com>
Date: Wed, 17 Feb 2010 11:55:07 -0600

> A userland command to set the LLTEMAC MAC address,
> i.e. "ifconfig eth0 hw addr xx:yy:zz:pp:dd:qq",
> results in a device address of 00:01:xx:yy:zz:pp.
> Correct this.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

Applied.
