Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZDBOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZDBOQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZDBOPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:15:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:46280 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758616AbZDBOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:15:50 -0400
Date: Thu, 2 Apr 2009 22:15:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, jarkao2@gmail.com, vernux@us.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090402141539.GA435@gondor.apana.org.au>
References: <20090323.013749.122944803.davem@davemloft.net> <20090402141342.GA377@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402141342.GA377@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:13:42PM +0800, Herbert Xu wrote:
>
> Come on guys, if this lock is a problem. go out and buy a proper
> NIC that supports multiequeue TX!

Nevermind, I was reading old emails again :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
