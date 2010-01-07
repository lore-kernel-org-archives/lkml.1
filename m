Return-Path: <linux-kernel-owner+w=401wt.eu-S932961Ab0AGJRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab0AGJRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932944Ab0AGJRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:17:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34608
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932884Ab0AGJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:17:39 -0500
Date: Thu, 07 Jan 2010 01:17:47 -0800 (PST)
Message-Id: <20100107.011747.54958411.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/dvb/dvb-core/dvb_net.c: use %pM to show
 MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001050945.21446.hartleys@visionengravers.com>
References: <201001050945.21446.hartleys@visionengravers.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Tue, 5 Jan 2010 09:45:21 -0700

> Use the %pM kernel extension to display the MAC address and mask.
> 
> The only difference in the output is that the output is shown in
> the usual colon-separated hex notation.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied.
