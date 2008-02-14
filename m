Return-Path: <linux-kernel-owner+w=401wt.eu-S964842AbYBNBl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842AbYBNBl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbYBNBlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:41:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54757
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756314AbYBNBlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:41:15 -0500
Date: Wed, 13 Feb 2008 17:41:47 -0800 (PST)
Message-Id: <20080213.174147.115433928.davem@davemloft.net>
To: bunk@kernel.org
Cc: paul.moore@hp.com, jmorris@namei.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make secmark_tg_destroy() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213212940.GH3383@cs181133002.pp.htv.fi>
References: <20080213212940.GH3383@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 13 Feb 2008 23:29:40 +0200

> This patch makes the needlessly global secmark_tg_destroy() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
