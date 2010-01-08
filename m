Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559Ab0AHA6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0AHA6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541Ab0AHA6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:58:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55035
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab0AHA6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:58:49 -0500
Date: Thu, 07 Jan 2010 16:58:58 -0800 (PST)
Message-Id: <20100107.165858.199044029.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, macro@linux-mips.org
Subject: Re: [PATCH] drivers/net/defxx.c: use %pMF to show MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001071624.20139.hartleys@visionengravers.com>
References: <201001071624.20139.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Thu, 7 Jan 2010 16:24:19 -0700

> Use the %pMF kernel extension to display the MAC address.
> 
> The address will still be displayed in the FDDI Canonical format.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
