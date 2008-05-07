Return-Path: <linux-kernel-owner+w=401wt.eu-S1771746AbYEGVtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1771746AbYEGVtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbYEGVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:48:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765349AbYEGVsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:48:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: WARNING: at arch/x86/kernel/genapic_64.c:86
Date: Wed, 7 May 2008 23:48:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <c4e36d110804220204h3043e526xee3966876355cde0@mail.gmail.com> <c4e36d110805061622j7025b4f9ufb4f0d181351e16a@mail.gmail.com> <48210BBE.4050705@googlemail.com>
In-Reply-To: <48210BBE.4050705@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072348.41093.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Gabriel C wrote:
> Zdenek Kabelac wrote:
> > 2008/5/7 Rafael J. Wysocki <rjw@sisk.pl>:
> >> On Tuesday, 22 of April 2008, Zdenek Kabelac wrote:
> >>  > Hello
> >>  >
> >>  > I've update to the current commit 2.6.25
> >>  > 8a81f2738f10ca817c975cec893aa58497e873b2
> >>
> >>  Does it still happen with the current -git?
> >>
> >>
> >>
> > 
> > The last day for this backtrace is from 2nd May in my kernel log.
> > So I guess it's been fixed in current git.
> > 
> 
> Yes this was fixed by Andi Kleen , commit f6c133f7d5ee3b82f5b34b988e897ea38cd8219c

OK, thanks.
