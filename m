Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZDPJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZDPJoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZDPJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:43:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38765
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbZDPJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:43:56 -0400
Date: Thu, 16 Apr 2009 02:43:47 -0700 (PDT)
Message-Id: <20090416.024347.22681928.davem@davemloft.net>
To: anemo@mba.ocn.ne.jp
Cc: marcin.slusarz@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phylib: Fix delay argument of schedule_delayed_work
From: David Miller <davem@davemloft.net>
In-Reply-To: <1239811551-6101-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239811551-6101-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date: Thu, 16 Apr 2009 01:05:51 +0900

> The commit a390d1f3 ("phylib: convert state_queue work to
> delayed_work") missed converting 'expires' value to 'delay' value.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Applied, thank you very much.
