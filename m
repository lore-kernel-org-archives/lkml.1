Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYC1W6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYC1W6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYC1W56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:57:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbYC1W55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:57:57 -0400
Date: Fri, 28 Mar 2008 15:57:51 -0700 (PDT)
Message-Id: <20080328.155751.06268684.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803282334.29975.vda.linux@googlemail.com>
References: <200803280036.59311.vda.linux@googlemail.com>
	<20080327.175212.119805454.davem@davemloft.net>
	<200803282334.29975.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 28 Mar 2008 23:34:29 +0100

> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Applied, thanks!
