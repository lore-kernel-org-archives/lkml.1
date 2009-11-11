Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZKKTkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZKKTkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZKKTks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:40:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42015
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758514AbZKKTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:40:47 -0500
Date: Wed, 11 Nov 2009 11:41:14 -0800 (PST)
Message-Id: <20091111.114114.228545645.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-11-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091111.112031.184370997.davem@davemloft.net>
References: <20091111172255.GH4392@tuxdriver.com>
	<20091111.112031.184370997.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 11 Nov 2009 11:20:31 -0800 (PST)

> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 11 Nov 2009 12:22:55 -0500
> 
>> P.S.  Due to the aformentioned iwlwifi fix, this will cause -next
>> conflicts for sfr.  You may want to pull net-2.6 into net-next-2.6 after
>> pulling this.  The iwlwifi conflicts can be resolved by taking the bigger
>> hunks...
> 
> Yep, I noticed this, I'll sort it out, thanks.

I just pushed out the merge to net-next-2.6, please double
check my work.

Thanks!
