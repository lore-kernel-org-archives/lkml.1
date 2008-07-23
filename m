Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYGWWUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYGWWUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYGWWUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:20:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50117
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbYGWWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:20:05 -0400
Date: Wed, 23 Jul 2008 15:20:05 -0700 (PDT)
Message-Id: <20080723.152005.243538730.davem@davemloft.net>
To: tytso@MIT.EDU
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1KLm0c-0002O6-RO@closure.thunk.org>
References: <E1KLm0c-0002O6-RO@closure.thunk.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Theodore Ts'o" <tytso@MIT.EDU>
Date: Wed, 23 Jul 2008 17:36:30 -0400

> 
> Is this a new one?  I don't think I've seen this on LKML....

Yes, we have, we're trying to work it out on netdev.
