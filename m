Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZHBUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZHBUaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZHBUaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:30:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZHBUaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:30:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Date: Sun, 2 Aug 2009 22:30:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.cJ.jYObKB@chimera> <20090802154546.55418e52@varda>
In-Reply-To: <20090802154546.55418e52@varda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908022231.00011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009, Alejandro Riveira Fernández wrote:
> El Sun, 26 Jul 2009 22:45:27 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> escribió:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> 
>  Sorry for the delay i did not have the time to test 2.6.31-rc* until now.
> Tried 2.6.31-rc5 the problem persist. The revert still fixes the issue; so
> the bug should be still present.
> 
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> > Subject		: rt2x00: slow wifi with correct basic rate bitmap
> > Submitter	: Alejandro Riveira <ariveira@gmail.com>
> > Date		: 2009-05-22 13:32 (66 days old)

Thanks for the update.

Rafael
