Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0BSKKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:10:53 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58976 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0BSKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PnsojRsI9F0JfWK8r+7qgF+CCJUdPVetaj/cTTl8/3ALcorL7EJ6Vn4+QpXufnogbS
         3cw8Cc8EixuJ24xnrrnHgcIzq/5ek9eynCnVo0ht9BA2nPHS7twsDf0bMCMmr9G74GrS
         IqR/5pYuZyQ1s8jjgnRAmiNKCverIR55E0pw0=
MIME-Version: 1.0
In-Reply-To: <m1d402t2qp.fsf@fess.ebiederm.org>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com>
	 <m1d402t2qp.fsf@fess.ebiederm.org>
Date: Fri, 19 Feb 2010 11:10:47 +0100
Message-ID: <2d460de71002190210qb9d5685n2fca0e7eff011b04@mail.gmail.com>
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Gilbert <bgilbert@cs.cmu.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 02:48, Eric W. Biederman <ebiederm@xmission.com> wrote:

> Why did you replaced a tab with spaces here??

The first tab is indentation, displaying the logical nesting level.

The second tab including the whitespaces after it was formatting.

Although the official tab width in the linux kernel is 8 chars, not
all code adheres to this rule. Maintaining a clear separation between
indentation and formatting, i.e. using tabs as initially intended, helps
to keep everyone happy, no matter what tab width they use.

If this change is actually controversial, I have no problem removing
this part from the patch. However, it is my _strong_ feeling, that it is
beneficial to keep it.


If there is any wider interest in this topic, I am more than willing to
take this up on the main list in a separate thread. Unless it has
already been discussed, of course.


Thanks for looking at the patch,
Richard
