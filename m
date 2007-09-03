Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbXICKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbXICKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXICKgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:36:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:53042 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXICKgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qHQ+ADlhPEkUJqQUF+a6MYhewbt97oX9pL6udbkLmwMqYmQk0nPtVfve5UnWKjjxEmOZy8OYSyEJiFDZHHhgfFQgD/qzj5LV+IkCm+b347195pNbmwXHHbscVyLlmGnTqg0hznyZtNZnpqHBba452+kUSLS5+wmO25rvM949j54=
Message-ID: <6bffcb0e0709030336g8d9fa1ao92b9d793fb18c66a@mail.gmail.com>
Date: Mon, 3 Sep 2007 12:36:09 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [1/4] 2.6.23-rc5: known regressions
Cc: "Jan Dittmer" <jdi@l4x.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
In-Reply-To: <20070903102347.GQ16016@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46DBDD6E.9020007@googlemail.com> <46DBDDF0.3090203@l4x.org>
	 <6bffcb0e0709030314t28c0102dr41f3c7b75b134cfa@mail.gmail.com>
	 <20070903102347.GQ16016@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Sep 03, 2007 at 12:14:05PM +0200, Michal Piotrowski wrote:
> > On 03/09/07, Jan Dittmer <jdi@l4x.org> wrote:
> > > Michal Piotrowski wrote:
> > > > Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> > > > References      : http://lkml.org/lkml/2007/8/6/43
> > > > Last known good : alpha: 2.6.22-git8
> > > >                   xtensa: 2.6.22-git6
> > > > Submitter       : Jan Dittmer <jdi@l4x.org>
> > > > Caused-By       : ?
> > > > Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
> > > > Status          : unknown
> > >
> > > Both are fixed as of -rc5
> >
> > Thanks. I will try to figure out who fixed these bugs.
>
> alpha was commit aa137f9d29d30592774c727ec5cfcf9891e576fa
> xtensa was commit b5f281a62761887e7cb5f60fa81f7cd052fec5cb

Thanks!

>
> > Regards,
> > Michal
>
> cu
> Adrian

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
