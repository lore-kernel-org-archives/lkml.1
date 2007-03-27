Return-Path: <linux-kernel-owner+w=401wt.eu-S933978AbXC0FRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbXC0FRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933994AbXC0FRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:17:10 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:18883 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbXC0FRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gjw3N3wBUhsX7nXKwY+akQ3H7kxSVe9snOlGB3wcxqUOV6nC7Haghts/xXvKVUjv5fNXpuJe3M5MqN8BdB+Yxc1KxwWqVEEalZYHKyMWqPJ1JsdPxlWa0WWX7t3CdmQstu1xJsPjivERWjsbJdUbMihneVxqtVfXbm5uCpyv8LY=
Message-ID: <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>
Date: Tue, 27 Mar 2007 01:17:06 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Wu, Bryan" <bryan.wu@analog.com>, "Arnd Bergmann" <arnd@arndb.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
In-Reply-To: <20070327044914.GA26099@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174903941.32691.72.camel@roc-desktop>
	 <200703262345.09489.arnd@arndb.de>
	 <1174966837.6966.13.camel@roc-desktop>
	 <20070327035734.GA25883@linux-sh.org>
	 <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>
	 <20070327044914.GA26099@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Mar 27, 2007 at 12:34:25AM -0400, Mike Frysinger wrote:
> > On 3/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > >You should really consider the latter for getting updates merged in the
> > >future
> >
> > we're planning for this, but the short term it isnt doable for us
>
> If you think mangling patches by hand is a more effective use of time, no
> one is stopping you -- some people even prefer that. On the other hand, if
> you're struggling with an effective methodology before things are merged,
> what reason is there to suspect that things will get better afterwards?

we have a lot of infrastructure that the SCM is part of and at the
moment, git is not a supported SCM

i'm not saying the current system is easy, just that we cant integrate
git in the short term, so we'll continue spanking Bryan with the
overhead :/
-mike
