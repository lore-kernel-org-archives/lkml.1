Return-Path: <linux-kernel-owner+w=401wt.eu-S939039AbXGSQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939039AbXGSQbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765729AbXGSQa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:30:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:28158 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765408AbXGSQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N7xmgY2VjvBRBPM5L/1kQ4Zs6w10n62h/onv8GGBdlqlwLPwdbiFMCiFLUGu1zowaZJSKcEpPzVqdLuJawPfaAavRfa1/r9TRscA9TkC6CPNRTIFROQvlBLPID3SMK78V9EVZZcsIdGgMFIdO3tLi+YvPP8GXgobX/eV0hiMSb8=
Message-ID: <625fc13d0707190930j381ea4f2x462a8269db269388@mail.gmail.com>
Date: Thu, 19 Jul 2007 11:30:54 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 0/5] Freezer update
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <20070718010353.27965df7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707180929.31511.rjw@sisk.pl>
	 <20070718010353.27965df7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:

> > so please consider them as 2.6.23 material.
>
> The door for new 2.6.23 material shut two weeks ago.  Here, at least.

So do you have a general guideline as to when you'd like patches sent
to you for the next merge window?  The releases are fairly
predictable, so perhaps something like one of the later -rc candidates
for the upcoming release?

E.g. patches for 2.6.24 should be to you by 2.6.23-rc<N>?

Of course, this is assuming they go through you.  I'm not trying to
complicate things.  Just trying to get an understanding of how you'd
like it to work.

josh
