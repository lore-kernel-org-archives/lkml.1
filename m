Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZCTIem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZCTIem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZCTIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:34:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55693
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbZCTIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:34:10 -0400
Date: Fri, 20 Mar 2009 01:33:56 -0700 (PDT)
Message-Id: <20090320.013356.246706473.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: sven@thebigcorporation.com, ghaskins@novell.com, vernux@us.ibm.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: [PATCH] net: reorder struct Qdisc for better SMP performance
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C250DB.3050707@cosmosbay.com>
References: <49C1DCDF.6050300@cosmosbay.com>
	<20090318.225822.179893347.davem@davemloft.net>
	<49C250DB.3050707@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 19 Mar 2009 15:04:11 +0100

> [PATCH] net: reorder struct Qdisc for better SMP performance

Applied, thanks.

