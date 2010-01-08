Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581Ab0AHA7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0AHA7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568Ab0AHA65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:58:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55040
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab0AHA64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:58:56 -0500
Date: Thu, 07 Jan 2010 16:59:04 -0800 (PST)
Message-Id: <20100107.165904.102147705.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/skfp/skfddi.c: use %pMF to show MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001071627.46569.hartleys@visionengravers.com>
References: <201001071627.46569.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Thu, 7 Jan 2010 16:27:46 -0700

> Use the %pMF kernel extension to display the MAC address.
> 
> The address will still be displayed in the FDDI Canonical format.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
