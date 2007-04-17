Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXDQOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXDQOBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbXDQOBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:01:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:39978 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXDQOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nr+m3QCyvw286klyaOLk78fIg65wwzZ/Jj7SZZNQckoQei/oY19un00C6K7TMbXN0Sy3918tnmsoMphO9bvytTfiTD/K+e69ByUDLMERnca9308mlsjPEQo8NxP3Aro5D/Cmn4UDB2tN/96iyKkOkJxyT9BmWa64z7BZIetEFXg=
Message-ID: <38b2ab8a0704170701p69fd547dwe3e2523ba5798b55@mail.gmail.com>
Date: Tue, 17 Apr 2007 16:01:51 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417130431.GA8685@2ka.mipt.ru>
	 <E1HdnwX-0005U1-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Yep.  We don't need such a flag anyway.  All we need is a way to tweak
> the priority and Bob's your uncle.
>

Could you elaborate please, I don't see how you prevent others users
to use this module with priority.

Priority is a stuff that tells you which aes implementation to use but
it does not prevent an implementation to be used several times...

Thanks
-- 
Francis
