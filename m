Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZAOR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZAOR3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZAOR3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:29:02 -0500
Received: from gw2.cosmosbay.com ([86.64.20.130]:54997 "EHLO gw2.cosmosbay.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbZAOR3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:29:01 -0500
Message-ID: <496F7251.7030300@cosmosbay.com>
Date: Thu, 15 Jan 2009 18:28:49 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ionut Leonte <ionut.leonte@gmail.com>
CC: Pekka Pietikainen <pp@ee.oulu.fi>,
       =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] b44: GFP_DMA skb should not escape from driver
References: <20090115111537.GA994@gondor.apana.org.au> <496F4AD4.9080201@cosmosbay.com> <496F690A.2090606@cosmosbay.com> <200901151914.11421.ionut.leonte@gmail.com>
In-Reply-To: <200901151914.11421.ionut.leonte@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw2.cosmosbay.com [127.0.0.1]); Thu, 15 Jan 2009 18:28:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ionut Leonte a écrit :
> Applied, seems to fix the problem.

Thanks for your report and testing !

