Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0BSQfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:35:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:24196 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0BSQfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j9NY1EJO12fyfOYBSNOVbgdvdWeNpLb6KGYOxvjchJTrhso4EgMytHiT2f2jIUW7ql
         6495CLNmFdONhERf6sWUAnIlgBrOmHiRCnl+uRaOSbABs8aFRnhsdYXf0bnU3TbwtIKJ
         8gpsnJA7fwLSojSXDbTmflYizGjM1wNMtNP0k=
MIME-Version: 1.0
In-Reply-To: <20100219121752.GA21682@gondor.apana.org.au>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
	 <m1d402t2qp.fsf@fess.ebiederm.org>
	 <2d460de71002190210qb9d5685n2fca0e7eff011b04@mail.gmail.com>
	 <20100219121752.GA21682@gondor.apana.org.au>
Date: Fri, 19 Feb 2010 17:35:35 +0100
Message-ID: <2d460de71002190835t29c6bd6bjbee8e2f787d9ab49@mail.gmail.com>
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-crypto@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Gilbert <bgilbert@cs.cmu.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 13:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> FWIW I don't like this change so I'm dropping it.

Dropping the change or the whole patch? I.e. should I resubmit
without that part?


Richard
