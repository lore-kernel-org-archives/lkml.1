Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074Ab0AKUA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0AKUA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017Ab0AKUA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:00:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0AKUA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:00:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [Bug #14874] Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
Date: Mon, 11 Jan 2010 21:01:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joshua Covington <joshuacov@googlemail.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.1h.vNlSLB@chimera> <43e72e891001110705w43524cc6pac1ff6c971926eaf@mail.gmail.com>
In-Reply-To: <43e72e891001110705w43524cc6pac1ff6c971926eaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112101.36950.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Luis R. Rodriguez wrote:
> On Sun, Jan 10, 2010 at 2:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> This should be closed now.

The patch linked below is not present in the Linus' tree at the moment AFAICS.
Has it been fixed in a different way?

Rafael


> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14874
> > Subject         : Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
> > Submitter       : Joshua Covington <joshuacov@googlemail.com>
> > Date            : 2009-12-25 00:49 (17 days old)
> > Handled-By      : Luis R. Rodriguez <mcgrof@gmail.com>
> > Patch           : http://bugzilla.kernel.org/attachment.cgi?id=24335
