Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXFYVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXFYVva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbXFYVvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:51:14 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:34168 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904AbXFYVvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:51:12 -0400
Date: Mon, 25 Jun 2007 23:49:02 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: harald@skogtun.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <4680384e.iAYvC5ix5Dbya44W%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
 <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
 <1182785277.12109.121.camel@pmac.infradead.org>
 <87wsxrdi6e.fsf@basilikum.skogtun.org>
 <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
 <87ir9byak9.fsf@basilikum.skogtun.org>
 <87ejjzyac0.fsf@basilikum.skogtun.org>
In-Reply-To: <87ejjzyac0.fsf@basilikum.skogtun.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen <harald@skogtun.org> wrote:

> Harald Arnesen <harald@skogtun.org> writes:
>
> > Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) writes:
> >
> >>> If I actually install smake, as Jörg recommends, the message becomes:
> >>> smake: Can't find any source for 'CCOM_suncc'.
> >>> smake: Couldn't make 'CCOM_suncc'.
> >>
> >> Well, I was in hope that a small typo (in special as the correct spelling is in 
> >> the file README.compile) should not be a problem.
> >>
> >> You need to use CCOM=suncc 
> >
> > Then it (star, I haven't tried cdrtools yes) compiles and links fine.
> > There must be something wrong with your Linux installation.
>
> FYI, cdrtools also compile and link fine with Sun's C compiler.

Mmmmm, if you call "cdrecord -scanbus", what do you get?

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
