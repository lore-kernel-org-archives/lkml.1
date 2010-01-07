Return-Path: <linux-kernel-owner+w=401wt.eu-S932798Ab0AGJTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0AGJTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017Ab0AGJT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:19:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39627
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933031Ab0AGJTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:19:15 -0500
Date: Thu, 07 Jan 2010 01:19:23 -0800 (PST)
Message-Id: <20100107.011923.222222050.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c: use %pM to show MAC
 address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001051001.55024.hartleys@visionengravers.com>
References: <201001051001.55024.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 5 Jan 2010 10:01:54 -0700

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
