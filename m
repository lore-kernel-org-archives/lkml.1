Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZKKGbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZKKGbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZKKGbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:31:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59179
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbZKKGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:31:20 -0500
Date: Tue, 10 Nov 2009 22:31:47 -0800 (PST)
Message-Id: <20091110.223147.68077469.davem@davemloft.net>
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH]Use DMA_BIT_MASK(44) instead of deprecated
 DMA_44BIT_MASK
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911081759.27263.mitov@issp.bas.bg>
References: <200911081759.27263.mitov@issp.bas.bg>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>
Date: Sun, 8 Nov 2009 17:59:27 +0200

> Use DMA_BIT_MASK(44) instead of deprecated DMA_44BIT_MASK
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

Applied to net-next-2.6
