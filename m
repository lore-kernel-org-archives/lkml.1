Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYEOFfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYEOFfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYEOFfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:35:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36415
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbYEOFfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:35:21 -0400
Date: Wed, 14 May 2008 22:35:16 -0700 (PDT)
Message-Id: <20080514.223516.71667347.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: fubar@us.ibm.com, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] bonding: handle case of device named bonding_master
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080514181528.1ff1791a@extreme>
References: <20080514170316.672f809d@extreme>
	<20080514181257.74fbb5aa@extreme>
	<20080514181528.1ff1791a@extreme>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Wed, 14 May 2008 18:15:28 -0700

> If device already exists named bonding_masters, then fail. This is a wierd
> corner case only a QA group could love.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Also applied, thanks a lot Stephen.
