Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZL2WP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZL2WP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZL2WPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:15:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbZL2WPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:15:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Subject: Re: [Bug #14846] acer-wmi kernel OOPS, cannot create duplicit sysfs name
Date: Tue, 29 Dec 2009 23:16:03 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.ck.mnhOLB@chimera> <200912291637.29088.oldium.pro@seznam.cz>
In-Reply-To: <200912291637.29088.oldium.pro@seznam.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292316.03831.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Oldrich Jedlicka wrote:
> Hi,
> 
> On Tuesday 29 of December 2009 at 16:09:57, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> When the patch is applied to 2.6.33-rc2, the regression goes away. The patch 
> fixes the problem.

Great, thanks for the update.

Rafael
