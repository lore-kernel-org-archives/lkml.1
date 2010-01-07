Return-Path: <linux-kernel-owner+w=401wt.eu-S932889Ab0AGJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab0AGJQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264Ab0AGJQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:16:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34598
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932855Ab0AGJQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:16:05 -0500
Date: Thu, 07 Jan 2010 01:16:12 -0800 (PST)
Message-Id: <20100107.011612.17260804.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pjones@redhat.com
Subject: Re: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC
 address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001050937.43896.hartleys@visionengravers.com>
References: <201001050937.43896.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 5 Jan 2010 09:37:43 -0700

> Use the %pM kernel extension to display the MAC address.
> 
> Also, remove the 'mac' variable and use nic->mac directly.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Acked-by: Peter Jones <pjones@redhat.com>

Applied.
