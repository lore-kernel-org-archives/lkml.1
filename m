Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZA2WUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZA2WUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZA2WUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:20:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44924 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZA2WUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:20:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: macbook pro radeon suspend issue
Date: Thu, 29 Jan 2009 23:19:37 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49812E3B.6050106@gmail.com> <200901291536.37348.rjw@sisk.pl> <4982045B.6090206@gmail.com>
In-Reply-To: <4982045B.6090206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901292319.37921.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > On Thursday 29 January 2009, Justin P. Mattock wrote:
> >   
> >> No sure if there is a bug report already or not.
> >> For the macbook pro(ATI chipset) suspend is broken.
> >> As for kernel version: latest git.
> >> Last week(before LCA, and during the week, since being no merges.)
> >> the system would wakeup, show a black screen and sit there. Now
> >> after a couple of merges have been completed The system wakes up,
> >> but instantly reboot's.
> >>
> >> I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
> >> no response
> >> for some reason or another.
> >> I can try and do a bisect, the only problem
> >> I have though, is I never labeled good/bad commits(forgot how too);
> >>
> >> In any case If I'm in an urgent need, of having  to suspend
> >> the system(not in anytime soon at the moment),
> >> then Ill just revert kernels to one that I know works.     :^)
> >>     
> >
> > Which is that?
> >
> > Rafael
> >
> >   
> O.K. I ended up grabbing the packages from debian
> to get it working.

Not sure what you mean.  Care to elaborate?

Rafael
