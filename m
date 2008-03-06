Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbYCFU04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbYCFU04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYCFU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:26:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYCFU0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:26:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Date: Thu, 6 Mar 2008 21:25:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200803030316.07165.rjw@sisk.pl> <47D03086.3000806@imap.cc>
In-Reply-To: <47D03086.3000806@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062125.54364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of March 2008, Tilman Schmidt wrote:
> On 03.03.2008 03:16 Rafael J. Wysocki wrote:
> 
> > Unresolved regressions
> > ----------------------
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10021
> > Subject		: Linux 2.6.25-rc2 regression: LVM cannot find volume group
> > Submitter	: Tilman Schmidt <tilman@imap.cc>
> > Date		: 2008-02-16 20:14
> > References	: http://lkml.org/lkml/2008/2/16/208
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > 		  Jiri Slaby <jirislaby@gmail.com>
> 
> Fixed in 2.6.25-rc4 by the introduction of CONFIG_SYSFS_DEPRECATED_V2.

Already closed.

Thanks,
Rafael
