Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZBVHhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZBVHhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 02:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZBVHhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 02:37:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55778
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbZBVHhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 02:37:39 -0500
Date: Sat, 21 Feb 2009 23:37:20 -0800 (PST)
Message-Id: <20090221.233720.204925051.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] ipv6: fix sparse warning: Using plain integer as
 NULL pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090222000541.17557.51181.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	<20090222000541.17557.51181.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sun, 22 Feb 2009 01:05:44 +0100

> Fix this sparse warning:
>   net/ipv6/xfrm6_state.c:72:26: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied, thanks.
