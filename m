Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZDDVEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZDDVEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZDDVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:04:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZDDVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:04:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 6/6] x86: unify power/cpu_(32|64).c
Date: Sat, 4 Apr 2009 23:04:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Sergio Luis <sergio@larces.uece.br>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>,
       x86 Maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <49D71EEE.30600@larces.uece.br> <20090330102502.GA1430@ucw.cz>
In-Reply-To: <20090330102502.GA1430@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904042304.25088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Pavel Machek wrote:
> Hi!
> 
> > x86: unify power/cpu_(32|64).c
> > 
> > This is the last unification step. Here we do remove one of the files
> > and rename the left one as cpu.c, as both are now the same.
> > Also update power/Makefile, telling it to build cpu.o, instead of
> > cpu_(32|64).o
> > 
> > Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> > Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> 
> 
> Whole series looks ok to me.
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

However, there's no way it can go in before 2.6.30 final.

I'm reviewing it at the moment.

Thanks,
Rafael
