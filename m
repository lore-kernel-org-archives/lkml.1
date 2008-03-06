Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbYCFWd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbYCFWd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYCFWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:33:14 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:50872 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYCFWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=muWHMBdl1gfIS0ToBGaUxKV/ftCkvrVOpctww1H2Xa+WXIlSmf4oNwiUE4MYTxEpePxTOmMPM42BFeaqWNJ5aiYT6WnXx2DzvRicMkm8SqpFpRRzSv0/aBUB0E07FQZNNzz+Mqs32iYaNRlPRtwgO+bgv9E3LzjecE+wi4HrjBc=
Message-ID: <4d8e3fd30803061433p4dc007bey9afcb8b5a3d4539b@mail.gmail.com>
Date: Thu, 6 Mar 2008 23:03:10 +0030
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] checkpatch: Make some text more consinstent and informative
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080306102026.GB25123@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47CF0748.3060203@gmail.com> <20080306102026.GB25123@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/08, Andy Whitcroft <apw@shadowen.org> wrote:
> On Wed, Mar 05, 2008 at 09:49:12PM +0100, Paolo Ciarrocchi wrote:
> > Hi Andy,
> >
> > Now messages about missing spaces or not needed spaces are in the format:
> > space is required
> > space is not required
> >
> > Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
>
> The current version (which your patch has crossed with) has these changed
> to "required" and "prohibited" respectivly, to remove the ambiguity
> introduced by
> tehe "no spaces X" form.
>
> I did consider and reject the "is not required" form. In english this
> does not correct carry the "must not be present" meaning, it more means
> "may or may not be present at your option". Which is not what we are
> trying to say either.

yes, i tend to agree.

> Hopefully the new wording is clearer to native and non-native english
> speakers alike.

i had a look at the next branch, i really like the new output. Very nice work.

> Thanks for doing the patch even so.

you are welcome, i'll keep tracking the next branch.

ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
