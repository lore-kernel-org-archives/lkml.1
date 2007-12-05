Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXLEF4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXLEF4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 00:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXLEF4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 00:56:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:19988 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLEF4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 00:56:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FoYes0IgsCDZZ9/hZyXJsaGeYUfrIzNp9cLWrSZVt+l9rFfRhX5fXV9DfEyKnaRLZoEOy9wrDkT+l0KmCBiWHht2+olbORGdLzeIThJW3xqUYzTE3L/nMkWhzIaN+Vxw6wqY5xEdd/w1kqkr96eW+xO8DlzUZQlDyz0bc+eqCUI=
Message-ID: <b25c3fa70712042156h27043f47k5e3959be01a1234a@mail.gmail.com>
Date: Wed, 5 Dec 2007 14:56:04 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] NET: ASSERT_RTNL in __dev_set_promiscuity makes debug warning
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20071205053607.GA10589@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000001c8365a$e0e500c0$9c94fea9@jason>
	 <E1IzgPL-0006HB-00@gondolin.me.apana.org.au>
	 <006001c836ff$f0d59a30$9c94fea9@jason>
	 <20071205053607.GA10589@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/5, Herbert Xu <herbert@gondor.apana.org.au>:
> The idea is to not touch the unicast stuff at all on the multicast path.
>
> Anyway, this was discussed on netdev so please check the archives because
> there is more to this than just changing the multicast handling.  We also
> talked about consolidating the driver interface so that all these calls
> have the same environment rather than the mix-and-match that we have now.
>

Thanks again Herbert,
I'll take a look at old discussions.

Thanks.
Joonwoo
