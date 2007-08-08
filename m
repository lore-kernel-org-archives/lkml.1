Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbXHHEz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbXHHEz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXHHEzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:55:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52812
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbXHHEzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:55:10 -0400
Date: Tue, 07 Aug 2007 21:55:07 -0700 (PDT)
Message-Id: <20070807.215507.26532842.davem@davemloft.net>
To: larry.finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <46B94C12.2000301@lwfinger.net>
References: <46B943D3.9020207@lwfinger.net>
	<20070807.213724.27783161.davem@davemloft.net>
	<46B94C12.2000301@lwfinger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <larry.finger@lwfinger.net>
Date: Tue, 07 Aug 2007 23:52:34 -0500

> Yes, it is most likely coming from udev. Do you know who maintains
> udev? Google didn't give an answer in the first two pages.

I may be mis-remembering but I thought Greg KH was at the
helm at least at one point.
