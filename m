Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbZBXXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbZBXXAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZBXXAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:00:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZBXXAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:00:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Mohr <andi@lisas.de>
Subject: Re: Suspend regression with 2.6.29-rc
Date: Tue, 24 Feb 2009 23:59:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
References: <20090224205227.GA17485@rhlx01.hs-esslingen.de>
In-Reply-To: <20090224205227.GA17485@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242359.49802.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Andreas Mohr wrote:
> What, no_console_suspend of course ;)
> 
> Needless to say I'm also stuck as always, waiting for -rc resume regressions
> (due to i945 I think, -rc4 currently) to vanish
> (I believe -rc6 wouldn't fix it yet, may try -rc7 then).
> How many suspend/resume regression reports did we have in 2.6.29-rc? 5? 6? 7?

Probably more. :-(

Unfortunately, we had too many changes affecting suspend-resume during this
cycle, but that only turned out after the fact.  Moreover, all of them were
done in response to problem reports, but our fixes happened to break things on
systems that were not affected by the original issues being fixed.

> When did I first have 30+ working suspend/resumes on a desktop PC? 2001?
> 2000? 1999?
> I'm not entirely sure whether I can achieve similar reliability
> on a convincing number of desktops 10 years later...

Actually, I can.

Thanks,
Rafael
