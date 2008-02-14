Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbYBNBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbYBNBjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbYBNBjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:39:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59790
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761211AbYBNBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:39:13 -0500
Date: Wed, 13 Feb 2008 17:39:44 -0800 (PST)
Message-Id: <20080213.173944.256911535.davem@davemloft.net>
To: bunk@kernel.org
Cc: xemul@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6 patch] unexport __inet_hash_connect
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213212946.GK3383@cs181133002.pp.htv.fi>
References: <20080213212946.GK3383@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 13 Feb 2008 23:29:46 +0200

> This patch removes the unused EXPORT_SYMBOL_GPL(__inet_hash_connect).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
