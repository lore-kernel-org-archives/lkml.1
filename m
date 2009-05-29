Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZE2I55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZE2I55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZE2I5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:57:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36760
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085AbZE2I5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:57:47 -0400
Date: Fri, 29 May 2009 01:57:47 -0700 (PDT)
Message-Id: <20090529.015747.109057209.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 1/2] cxgb3: move away from LLTX
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090529075823.30669.28885.stgit@speedy5>
References: <20090529075823.30669.28885.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 29 May 2009 00:58:24 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> cxgb3 no longer advertizes LLTX.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

You might want to mention that these two patches depend
upon the 2.6.30 cxgb3 patches you also submitted at this
time and aren't in the tree yet. :-/

