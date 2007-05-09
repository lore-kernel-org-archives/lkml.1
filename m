Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbXEIIpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbXEIIpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXEIIpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:45:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53987
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbXEIIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:45:13 -0400
Date: Wed, 09 May 2007 01:45:14 -0700 (PDT)
Message-Id: <20070509.014514.124869407.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: multi-second freezes with current GIT?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070509014328.35d1d087.akpm@linux-foundation.org>
References: <1178681360.7487.59.camel@Homer.simpson.net>
	<20070508.232326.44096869.davem@davemloft.net>
	<20070509014328.35d1d087.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 9 May 2007 01:43:28 -0700

> does
> 
> echo 40 > /proc/sys/vm/dirty_ratio
> echo 10 > /proc/sys/vm/dirty_background_ratio
> 
> fix it?

Yes, I was going to play with that, I'll report if anything
decisive happens.
