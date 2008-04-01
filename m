Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYDACgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYDACgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYDACgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:36:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYDACgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:36:05 -0400
Date: Mon, 31 Mar 2008 19:36:05 -0700 (PDT)
Message-Id: <20080331.193605.161051889.davem@davemloft.net>
To: bunk@kernel.org
Cc: chas@cmf.nrl.navy.mil, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] atm/idt77252.c: make 2 functions static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080330231216.GA28445@cs181133002.pp.htv.fi>
References: <20080330231216.GA28445@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 31 Mar 2008 02:12:16 +0300

> This patch makes the following needlessly global functions static:
> - idt77252_send()
> - idt77252_dev_close()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
