Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355Ab0AQIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0AQIal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 03:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348Ab0AQIah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 03:30:37 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48523 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0AQIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 03:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YtC8ykvlq29Zm2BGaQOILAu8Ui3kkVBKDc14u3LPcie9EsHJqGGwfS5lnBAAwq8AtI
         OtLnqs2A3zdr/Sriu4enj6i8FDxMgk1R/amQgkxhwhFlXItVebnYQfPkInVUYl4+EOUL
         M7bCSIMrm0ulMDc0T/TNUdW8vYBx/A4OjSC2I=
Date: Sun, 17 Jan 2010 10:27:31 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.ker>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Message-ID: <20100117082730.GA21619@redhat.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001162257.16277.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 10:57:16PM +0100, Rafael J. Wysocki wrote:
> On Saturday 16 January 2010, m.s.tsirkin@gmail.com wrote:
> > On Tue, Dec 29, 2009 at 04:05:30PM +0100, Rafael J. Wysocki wrote:
> > > [NOTES:
> > >  * There you go, another round of tracking regressions.  It's not too bad at
> > >    the moment, as far as the regressions from 2.6.32 are concerned, but we have
> > >    quite a few -stable regressions, apparently in the DRI area.
> > 
> > I have another one there :)
> > 
> > Immediately upon startup, screen is flickering (becomes
> > lighter and darker again). The problem occurs with kernels
> > 2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.
> 
> We've already had several reports like this already.
> 
> Care to review the bugs linked to http://bugzilla.kernel.org/show_bug.cgi?id=14885
> and check if none of them matches the problem you describe?
> 
> Rafael

Well, not obviously. I will try latest git as Linus suggested.

-- 
MST
