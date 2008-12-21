Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbYLUT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbYLUT4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYLUTzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:55:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYLUTzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:55:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.28-rc9-git1: Reported regressions from 2.6.27
Date: Sun, 21 Dec 2008 20:56:01 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <84144f020812210107k4be14431s4fb61f2d31da8621@mail.gmail.com>
In-Reply-To: <84144f020812210107k4be14431s4fb61f2d31da8621@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812212056.02246.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of December 2008, Pekka Enberg wrote:
> On Sat, Dec 20, 2008 at 11:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12156
> > Subject         : v2.6.28-rc2: x86_32 relocation regression?
> > Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> > Date            : 2008-11-24 21:19 (27 days old)
> > References      : http://marc.info/?l=linux-kernel&m=122756158220966&w=4
> 
> I think this one has a fix in x86.git:
> 
> http://lkml.org/lkml/2008/12/18/224

I've dropped it from the list at the Ingo's request.

Thanks,
Rafael
