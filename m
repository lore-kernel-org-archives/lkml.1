Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZCYGbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZCYGbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZCYGbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:31:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40109
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZCYGbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:31:40 -0400
Date: Tue, 24 Mar 2009 23:31:28 -0700 (PDT)
Message-Id: <20090324.233128.267694096.davem@davemloft.net>
To: daniel@caiaq.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@simtec.co.uk
Subject: Re: [PATCH 1/2] drivers/net/ax88796.c: take IRQ flags from
 platform_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237738361-10184-1-git-send-email-daniel@caiaq.de>
References: <1237738361-10184-1-git-send-email-daniel@caiaq.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>
Date: Sun, 22 Mar 2009 17:12:40 +0100

> This patch adds support to the ax88796 ethernet driver to take IRQ flags
> given by the platform_device definition.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Applied.
