Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZBIRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZBIRRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZBIRRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:17:32 -0500
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:51053 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754768AbZBIRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:17:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ezyKJBU0YwzGW0IUK7gZSCvu0B0HNj7/85h3d/uoyQItasCQmwYDrEAZcnyPjbYfKJdsboGMH5Z3W6Kb6gKg1fetY/nTvri+AOYfOWTJEHq4WuEoWUS46Xui1QngDjso;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
Date: Mon, 9 Feb 2009 09:17:26 -0800
User-Agent: KMail/1.9.10
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1228749555-21363-1-git-send-email-jirislaby@gmail.com> <498F558F.109@gmail.com> <20090208144537.ecf1019b.akpm@linux-foundation.org>
In-Reply-To: <20090208144537.ecf1019b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902090917.26450.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 8, 2009 2:45 pm Andrew Morton wrote:
> On Sun, 08 Feb 2009 22:58:39 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> > Jesse Barnes wrote:
> > > On Monday, December 08, 2008 7:19 am Jiri Slaby wrote:
> > >> Let it as serial, since it doesn't have subdevice in the form of
> > >> 0x00PS.
> > >>
> > >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > >
> > > Applied to my linux-next branch, thanks.
> >
> > Hi, did this get lost by a chance? I don't see it in your -next branch
> > anymore. Neither in any other branch nor upstream.
> >
> > BTW I got:
> > This patch was dropped because it was merged into mainline or a subsystem
> > tree from Andrew, so it had to be somewhere, I suppose...
>
> yes, it got lost.  I resurrected it.

Sorry I must have been thinking about another patch when I replied; the 
contents don't look familiar.  Anyway I'll pick it up now.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
