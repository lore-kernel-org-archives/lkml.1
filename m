Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZGXPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZGXPVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZGXPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:21:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51747 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZGXPVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:21:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ray Lee <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] kdesu broken
Date: Fri, 24 Jul 2009 17:21:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200907240145.31935.rjw@sisk.pl> <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
In-Reply-To: <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907241721.45943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Ray Lee wrote:
> On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
> > discussion about that, but I can't find it right now.  Any clues?
> 
> See the thread starting here: ("possible regression with pty.c commit")
>    http://lkml.org/lkml/2009/7/11/125

Thanks for the pointer.

Well, I thought we were expected to avoid breaking existing user space, even
if that were buggy etc.  

Best,
Rafael
