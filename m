Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330Ab0ADGBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0ADGBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 01:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0ADGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 01:01:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43535
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab0ADGBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 01:01:51 -0500
Date: Sun, 03 Jan 2010 22:01:54 -0800 (PST)
Message-Id: <20100103.220154.226474085.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mcarlson@broadcom.com
Subject: Re: [PATCH] broadcom: Fix &&/|| confusion in
 bcm54xx_adjust_rxrefclk()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B3B831A.507@gmail.com>
References: <4B3B831A.507@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 30 Dec 2009 17:43:06 +0100

> This always evaluates to true.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks Roel.
