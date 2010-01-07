Return-Path: <linux-kernel-owner+w=401wt.eu-S932849Ab0AGJP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0AGJP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820Ab0AGJPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:15:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34590
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932817Ab0AGJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:15:20 -0500
Date: Thu, 07 Jan 2010 01:15:28 -0800 (PST)
Message-Id: <20100107.011528.158875331.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/lanai.c: use %pM to show MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001050926.50117.hartleys@visionengravers.com>
References: <201001050926.50117.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 5 Jan 2010 09:26:49 -0700

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
