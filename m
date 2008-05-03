Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbYECP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbYECP2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbYECP16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:27:58 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:3190 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbYECP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YPbEra7FO4chGb8CyzTXRnBG08IoACS5RNL5OGvLtacoXd7cTkc6xpXgSvAVtn/39rd8Aloqj7UCSAFqKEgcX1MVo4BXSLPBtcNX1n0YCZfoIcjuNJGRFJRj1bhP/0L92D2vz1WmXqLRoHos6BNSgYFZrYvrfbtNrUrW7mZAYXs=
Date: Sat, 3 May 2008 23:31:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch] (revised) net/xfrm/xfrm_policy.c: replace timer with
	delayed_work
Message-ID: <20080503153151.GG3986@hack>
References: <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain> <20080501011123.GA4060@gondor.apana.org.au> <alpine.LFD.1.10.0805021323470.3349@localhost.localdomain> <20080502.165455.24687234.davem@davemloft.net> <20080503144647.GF3986@hack> <20080503150606.GA26898@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503150606.GA26898@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:06:06PM +0800, Herbert Xu wrote:
>On Sat, May 03, 2008 at 10:46:49PM +0800, WANG Cong wrote:
>> 
>> I will try if I can set up one, then test it.
>
>I'll throw them into my test systems here and see if they break.
>

Oh, thanks a lot! ;-)
