Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYEOFeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYEOFeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYEOFdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:33:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36403
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYEOFdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:33:54 -0400
Date: Wed, 14 May 2008 22:33:49 -0700 (PDT)
Message-Id: <20080514.223349.160084292.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: greg@kroah.com, fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: handle errors from device_rename
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080514181543.744b8286@extreme>
References: <20080514170316.672f809d@extreme>
	<20080514181543.744b8286@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 14 May 2008 18:15:43 -0700

> device_rename can fail with -EEXIST or -ENOMEM, so handle any problems.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, thanks.
