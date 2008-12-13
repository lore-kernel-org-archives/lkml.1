Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYLMFPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYLMFPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYLMFPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:15:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42636
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbYLMFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:15:33 -0500
Date: Fri, 12 Dec 2008 21:15:35 -0800 (PST)
Message-Id: <20081212.211535.151764794.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/9][v2] mISDN: make global symbols static or include
 header files
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a29.05ae660a.58c7.314c@mx.google.com>
References: <49419a29.05ae660a.58c7.314c@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> The warnings fixed by including an header file for the appropriate
> prototype are marked with "*", for all others the corresonponding
> symbol has been made static.  This patch fixes all such issues in
> mISDN.
> 
> Fix this sparse warnings:
 ...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied
