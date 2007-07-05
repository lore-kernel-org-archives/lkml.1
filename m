Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXGEKdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXGEKdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 06:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbXGEKc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 06:32:57 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:64455 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbXGEKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 06:32:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FawLfmxJE3yhfJAlTQpKvm6LMULvrhIi3vE1ohQODwAxkACkV9GzcCLb3N+67RQOjXrS33Y6Xg+JPANZw0U5/f/jPXYtVaOqxLxPcoSSqrZZe3F5BHSSvsL5BGPpl6YvDrNxFjPmncychnirJYfkjKJIUEghscou0eXS6OtEcKY=
Message-ID: <b637ec0b0707050332p6a5d31afpe3c0baa97da9b068@mail.gmail.com>
Date: Thu, 5 Jul 2007 12:32:55 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: The big suspend mess
Cc: "Pavel Machek" <pavel@ucw.cz>, "Paul Mackerras" <paulus@samba.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <468CC7F7.90803@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031456.40890.rjw@sisk.pl>
	 <1183497290.3388.4.camel@localhost.localdomain>
	 <200707032332.49694.rjw@sisk.pl>
	 <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
	 <20070704221952.GM3492@stusta.de> <20070705002747.GA2952@elf.ucw.cz>
	 <18060.16657.2143.11489@cargo.ozlabs.ibm.com>
	 <20070705093251.GB3228@elf.ucw.cz> <468CC7F7.90803@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 7/5/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Pavel Machek wrote:
> > On Thu 2007-07-05 10:53:37, Paul Mackerras wrote:
> >
> >> Pavel Machek writes:
> >>
> >>
> >>> 0. Get someone to sign up as a maintainer for suspend, so we have
> >>> someone to blame for the mess? :-)
> >>>
> >> I thought that was Rafael?
> >>
> >
> > Rafael is good job trying to fix suspend when he can, but we do not
> > actually have "SUSPEND" entry in MAINTAINERS file.
> >                                                               Pavel
> >
>
> Huch ?;)
>
> We do :p
>
> ...
>
> SOFTWARE SUSPEND:
> P: Pavel Machek
> M: pavel@suse.cz
> L: linux-pm@lists.linux-foundation.org
> S: Maintained
>

I think he means SUSPEND (aka suspend-to-ram) not "SOFTWARE SUSPEND"
(aka suspend-to-disk)
