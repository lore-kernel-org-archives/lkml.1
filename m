Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYENG0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYENG0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbYENG0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:26:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43707
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYENG0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:26:17 -0400
Date: Tue, 13 May 2008 23:26:11 -0700 (PDT)
Message-Id: <20080513.232611.97850193.davem@davemloft.net>
To: cooloney@kernel.org
Cc: marcel@holtmann.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, samuel@sortiz.org, graf.yang@analog.com
Subject: Re: [PATCH 1/1] [net/irda]: Fix a misalign access issue. (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210666187-739-1-git-send-email-cooloney@kernel.org>
References: <1210666187-739-1-git-send-email-cooloney@kernel.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <cooloney@kernel.org>
Date: Tue, 13 May 2008 16:09:47 +0800

> Replace u16ho with put/get_unaligned functions
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Applied, thanks everyone.
