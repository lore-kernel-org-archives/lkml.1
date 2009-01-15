Return-Path: <linux-kernel-owner+w=401wt.eu-S934652AbZAOX3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbZAOX3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762142AbZAOX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:29:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37586
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760913AbZAOX3T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:29:19 -0500
Date: Thu, 15 Jan 2009 15:29:21 -0800 (PST)
Message-Id: <20090115.152921.39574560.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: ionut.leonte@gmail.com, pp@ee.oulu.fi, mihai.dontu@gmail.com,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] b44: GFP_DMA skb should not escape from driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <496F7251.7030300@cosmosbay.com>
References: <496F690A.2090606@cosmosbay.com>
	<200901151914.11421.ionut.leonte@gmail.com>
	<496F7251.7030300@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 15 Jan 2009 18:28:49 +0100

> Ionut Leonte a écrit :
> > Applied, seems to fix the problem.
> 
> Thanks for your report and testing !

Patch applied, thanks everyone.
