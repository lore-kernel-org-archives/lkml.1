Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZKGCVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZKGCVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZKGCVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:21:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33748
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbZKGCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:21:50 -0500
Date: Fri, 06 Nov 2009 18:22:15 -0800 (PST)
Message-Id: <20091106.182215.230775367.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-11-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091106204034.GI2782@tuxdriver.com>
References: <20091106204034.GI2782@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 6 Nov 2009 15:40:34 -0500

> Three more intended for 2.6.32, two oops fixes and a revert of a patch
> that traded one bug for another.  One of the oops fixes reorders some
> cancel_delayed_work_sync calls and the other does some bit testing to
> avoid scheduling work after a device has been removed.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
