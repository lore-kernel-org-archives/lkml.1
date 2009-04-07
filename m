Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZDGVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZDGVKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZDGVKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:10:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZDGVKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:10:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP nx6325), NFS broken
Date: Tue, 7 Apr 2009 23:10:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <49DB69FA.1060202@lwfinger.net> <200904072249.02211.rjw@sisk.pl> <49DBBE3D.4020303@lwfinger.net>
In-Reply-To: <49DBBE3D.4020303@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072310.48724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 07 April 2009, Larry Finger wrote:
> >>
> >> Do you know anything about a regression that leads to "phy0: Failed to
> >> initialize wep: -2" messages? It is the 3rd one that I'm chasing and seems to
> >> affect all wireless drivers. For this one, removing and reinserting the driver
> >> corrects the problem.
> > 
> > No, I didn't know about this one.  Has it been reported anywhere already?
> 
> Only on the wireless mail list.

A pointer to the wireless mailing list thread would do too. :-)

> Once I get the bad commit, I'll post it in LKML.

OK, thanks.

Best,
Rafael
