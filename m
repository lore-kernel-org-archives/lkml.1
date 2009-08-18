Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZHREvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZHREvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbZHREvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:51:21 -0400
Received: from 1wt.eu ([62.212.114.60]:44420 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZHREvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:51:21 -0400
Date: Tue, 18 Aug 2009 06:50:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?Martin-=C9ric?= Racine <q-funk@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090818045048.GC11624@1wt.eu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl> <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com> <200908132034.34951.rjw@sisk.pl> <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com> <20090816205706.GB3463@elte.hu> <11fae7c70908161412v61fd233au5166e18f4c4d0931@mail.gmail.com> <20090816213407.GA30245@elte.hu> <11fae7c70908171402y18699abbs7a293fe9ff562388@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11fae7c70908171402y18699abbs7a293fe9ff562388@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:02:34AM +0300, Martin-Éric Racine wrote:
(...)
> > it's still a JPG - posting the transcribed oops in email text would
> > certainly help more folks looking over it.
> >
> > (painful i know ...)
> 
> I welcome suggestions for proper OCR software that can extract the
> text displayed therein. Manually transcribing it is too error-prone to
> even try.

Well, there are less risks of errors retyping by hand than passing via
an OCR. At least *you* know that everything you see are hex numbers, the
OCR does not. Eventhough it's quite annoying to do that by hand, it
generally takes less than 5 minutes to retype an oops, which is not that
much. Of course, the serial cable to another machine to get a panic dump
is the easiest solution ;-)

Willy

