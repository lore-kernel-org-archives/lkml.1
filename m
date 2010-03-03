Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0CCJHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:07:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55158
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909Ab0CCJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:07:28 -0500
Date: Wed, 03 Mar 2010 01:07:46 -0800 (PST)
Message-Id: <20100303.010746.134683403.davem@davemloft.net>
To: error27@gmail.com
Cc: netdev@vger.kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org,
       yanghy@cn.fujitsu.com, kaber@trash.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] cassini: fix off by one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100303082241.GA32640@bicker>
References: <20100303082241.GA32640@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Wed, 3 Mar 2010 11:22:41 +0300

> There are only 6 link_modes.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
