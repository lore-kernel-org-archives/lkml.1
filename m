Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbZDBILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbZDBILG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZDBIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:10:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33807
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbZDBIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:10:26 -0400
Date: Thu, 02 Apr 2009 01:10:15 -0700 (PDT)
Message-Id: <20090402.011015.152622937.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, oliver@neukum.org
Subject: Re: [PATCH 2/2 V3] kaweth: Clean up code
From: David Miller <davem@davemloft.net>
In-Reply-To: <49d3885f.OXwftgx2/UvY0Tex%Larry.Finger@lwfinger.net>
References: <49d3885f.OXwftgx2/UvY0Tex%Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 01 Apr 2009 10:29:35 -0500

> The driver kaweth yields a -EBUSY error when starting, and a -ETIME
> error when shutting down. These errors are avoided, and the RX status
> is further checked for other potential errors.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> DaveM,
> 
> This is 2.6.31 material as the imain change is to eliminate two trivial
> log messages.

Larry, please resubmit this to me when -rc1 is released.

Thanks!
