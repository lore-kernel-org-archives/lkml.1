Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZAORPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZAORPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZAORPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:15:33 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:38235 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZAORPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:15:33 -0500
From: Ionut Leonte <ionut.leonte@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] b44: GFP_DMA skb should not escape from driver
Date: Thu, 15 Jan 2009 19:14:11 +0200
User-Agent: KMail/1.9.9
Cc: Pekka Pietikainen <pp@ee.oulu.fi>,
       Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20090115111537.GA994@gondor.apana.org.au> <496F4AD4.9080201@cosmosbay.com> <496F690A.2090606@cosmosbay.com>
In-Reply-To: <496F690A.2090606@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151914.11421.ionut.leonte@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.23181
X-BitDefender-Spam: No (7)
X-BitDefender-SpamStamp: v1, build 2.7.20.59208, bayes score: 500(0),
 pbayes score: 214(7), neunet score: 0(0), flags: [VALID_REPLY],
 total: 7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, seems to fix the problem.
