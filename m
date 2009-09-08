Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbZIHWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbZIHWge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIHWgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:36:33 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:49488 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbZIHWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:36:32 -0400
From: Frans Pop <elendil@planet.nl>
To: GeunSik Lim <leemgs1@gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Wed, 9 Sep 2009 00:36:33 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, realnc@arcor.de,
       linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <200909082311.52229.elendil@planet.nl> <49b7c2350909081440s527caeb4r25671f991a18109e@mail.gmail.com>
In-Reply-To: <49b7c2350909081440s527caeb4r25671f991a18109e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909090036.34180.elendil@planet.nl>
X-OriginalArrivalTime: 08 Sep 2009 22:36:34.0847 (UTC) FILETIME=[D208C2F0:01CA30D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, you wrote:
> On Wed, Sep 9, 2009 at 6:11 AM, Frans Pop<elendil@planet.nl> wrote:
> >> Would it be possible to have a command line switch that allows to
> >> start the old textual mode?
> >
> > I got a private reply suggesting that --nogui might work, and it
> > does.
>
> Um. You means that you tested with runlevel 3(multiuser mode). Is it
> right? Frans. Can you share me your linux distribution for this test? I
> want to check with same conditions(e.g:linux distribution like fedora
> 11,ubuntu9.04 , runlevel, and so on.).

I ran it from KDE's konsole by just entering 'sudo latencytop --nogui' at 
the command prompt.

Distro is Debian stable ("Lenny"), which does not have differences between 
runlevels: by default they all start a desktop environment (if a display 
manager like xdm/kdm/gdm is installed). But if you really want to know, 
the runlevel was 2 ;-)

Cheers,
FJP
