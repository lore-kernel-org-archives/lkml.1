Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZBFJcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZBFJcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZBFJch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:32:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59582
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757990AbZBFJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:32:34 -0500
Date: Fri, 06 Feb 2009 01:32:30 -0800 (PST)
Message-Id: <20090206.013230.255280000.davem@davemloft.net>
To: yinghai@kernel.org
Cc: jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       aabdulla@nvidia.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] forcedeth: enable msix to default
From: David Miller <davem@davemloft.net>
In-Reply-To: <498BC46D.5080505@kernel.org>
References: <498BC3A8.9040203@kernel.org>
	<498BC46D.5080505@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 05 Feb 2009 21:02:37 -0800

> 
> Impact: change default
> 
> msix and napic can work again
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to net-next-2.6
