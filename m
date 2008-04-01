Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYDACf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYDACf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYDACfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:35:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56291
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYDACfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:35:15 -0400
Date: Mon, 31 Mar 2008 19:35:15 -0700 (PDT)
Message-Id: <20080331.193515.236966132.davem@davemloft.net>
To: bunk@kernel.org
Cc: chas@cmf.nrl.navy.mil, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make atm/he.c:read_prom_byte() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080330231155.GZ28445@cs181133002.pp.htv.fi>
References: <20080330231155.GZ28445@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 31 Mar 2008 02:11:55 +0300

> This patch makes the needlessly global read_prom_byte() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
