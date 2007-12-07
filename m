Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXLGIvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXLGIvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbXLGIvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:51:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48857
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbXLGIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:51:18 -0500
Date: Fri, 07 Dec 2007 00:51:18 -0800 (PST)
Message-Id: <20071207.005118.51611200.davem@davemloft.net>
To: crquan@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/20] net/xfrm/xfrm_state.c: use LIST_HEAD instead of
 LIST_HEAD_INIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <1196957383-5751-1-git-send-email-crquan@gmail.com>
References: <1196957383-5751-1-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Fri,  7 Dec 2007 00:09:43 +0800

> single list_head variable initialized with LIST_HEAD_INIT could almost
> always can be replaced with LIST_HEAD declaration, this shrinks the code
> and looks better.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Applied.
