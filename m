Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZKRNLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZKRNLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZKRNLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:11:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40092
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZKRNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:11:24 -0500
Date: Wed, 18 Nov 2009 05:11:41 -0800 (PST)
Message-Id: <20091118.051141.194815090.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.32] cxgb3: fix premature page unmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091118023828.16411.57681.stgit@localhost.localdomain>
References: <20091118023828.16411.57681.stgit@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Tue, 17 Nov 2009 18:38:28 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> unmap Rx page only when guaranteed that this page won't be
> used anymore to allocate rx page chunks.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied to net-2.6, thanks.
