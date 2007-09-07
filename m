Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXIGXjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXIGXjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXIGXjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:39:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:14767 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXIGXjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DEM3OCAu6gSYBS9aZGwA8ORk+bhCS52duz4Kc3FMA3Pglo7q+7c6HOxQ1S45aP7WK8rfEpfii/u7KUQu3jBELutbvJKdm6oBtPGYvSYLstxDiCHuc75PGp9QVWZWPpQOKsDuXUWApk9S0veQlqxs6vwgMm6EX1CNpYTlyDtyKMY=
Message-ID: <6bffcb0e0709071639y6bf7a3a0y86b1a2188d0ab1d7@mail.gmail.com>
Date: Sat, 8 Sep 2007 01:39:30 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1189072799.2745.68.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46DBDCF4.6040805@googlemail.com> <46DBDDC6.9030602@googlemail.com>
	 <1189072799.2745.68.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 06/09/2007, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2007-09-03 at 12:11 +0200, Michal Piotrowski wrote:
> > MTD
> >
> > Subject         : error: implicit declaration of function 'cfi_interleave'
> > References      : http://lkml.org/lkml/2007/8/6/272
> > Last known good : ?
> > Submitter       : Ingo Molnar <mingo@elte.hu>
> > Caused-By       : ?
> > Handled-By      : David Woodhouse <dwmw2@infradead.org>
> > Patch           : http://lkml.org/lkml/2007/8/9/586
> > Status          : patch available
>
> This isn't really a regression -- it's been like this for years.

Ok, I removed it from the KR list.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
