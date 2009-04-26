Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZDZRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZDZRoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZDZRob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:44:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZDZRoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:44:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Angel <angel@pearlgates.net>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI enabled
Date: Sun, 26 Apr 2009 19:43:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Jos van der Ende" <seraph@xs4all.nl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.ITD.zpE9JB@chimera> <20090426170729.3489b482.angel@pearlgates.net>
In-Reply-To: <20090426170729.3489b482.angel@pearlgates.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261943.45126.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, Angel wrote:
> On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> 
> I've tested with kernel 2.6.29.1. The problem still persists. While everything works fine with 2.6.28 or lower, starting X (both 1.3 and 1.5) with DRI enabled on a 2.6.29 kernel results in a garbled screen and unresponsive keyboard.

Thanks for the update.

Can you also test 2.6.30-rc3, please?

Rafael
