Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIBPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIBPz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbXIBPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:55:18 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24986 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbXIBPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eES3xOr23d3DAge0NA2x3PL/AkCwi24QsSOBxFos64G1qIbXE/CbVIwAlJklL1//KLdXwaA5auP7jTSmmBb1fJJhU91cshXr2iduOCrT+Qr4lsr5C/y9oqp3don5f3AyqACkExkIyHm3cBFZg5uhYgzH5CUpLwvcHcAfn2bkvOU=
Message-ID: <40f31dec0709020855q10d9227bld6e594ea57ba8142@mail.gmail.com>
Date: Sun, 2 Sep 2007 18:55:15 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <46D9C6A8.7070600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <2440910618305782004@pripojeni.net>
	 <20070830124054.GC5140@tuxdriver.com> <46D9C6A8.7070600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/1, Jiri Slaby <jirislaby@gmail.com>:
> John W. Linville napsal(a):
> > On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
> >> ath5k, use int as retval
> >>
> >> Convert some functions to return int and proper negative return value on
> >> error as we are used to.
> >
> > Since I didn't apply 1/5, this one didn't apply either.  It seems
> > fine overall, so if you rediff I'll be happy to apply.
>
> Ok, I'll do it, thanks,

Can somebody commit my resent changes from madwifi-svn (cleanups,
kconfig, remove_hw_ from filenames etc) ? I don't have git repository
;-(


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
