Return-Path: <linux-kernel-owner+w=401wt.eu-S1759794AbYEMIjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794AbYEMIjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbYEMIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:39:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757792AbYEMIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:39:30 -0400
Date: Tue, 13 May 2008 01:39:25 -0700 (PDT)
Message-Id: <20080513.013925.21464129.davem@davemloft.net>
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

> From: Graf Yang <graf.yang@analog.com>
> 
> Replace u16ho with put/get_unaligned functions
> 
> Signed-off-by: Graf Yang <graf.yang@analog.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Marcel, please ACK this I'd like to apply it.

Thanks.
