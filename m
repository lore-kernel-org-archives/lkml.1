Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYLMFON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYLMFON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbYLMFOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:14:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37016
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYLMFOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:14:00 -0500
Date: Fri, 12 Dec 2008 21:14:01 -0800 (PST)
Message-Id: <20081212.211401.140171586.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9][v2] mISDN: consistently define 'debug' as '*u_int'
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a25.02e2660a.1ba9.6cda@mx.google.com>
References: <49419a25.02e2660a.1ba9.6cda@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Impact: change data type for variable 'debug' from *int to *u_int,
> same for the argument type of mISDN_inittimer
> 
> In "core.h" mISDN_inittimer is declared with the argument type "*u_int", make
> the definition in "timerdev.c" match this.
> 
> This fixes also this warnings:
 ...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
