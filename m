Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZJZTzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZJZTzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZJZTzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:55:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbZJZTzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:55:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [Bug #14058] Oops in fsnotify
Date: Mon, 26 Oct 2009 20:57:37 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@parisplace.org>,
       Grant Wilson <grant.wilson@zen.co.uk>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.GQ.Bgf5KB@chimera> <1256586689.2775.6.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256586689.2775.6.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910262057.37334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Eric Paris wrote:
> On Mon, 2009-10-26 at 20:31 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.30 and 2.6.31.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Should have been fixed by:
> 9f0d793b52eb2266359661369ef6303838904855
> 
> At least I have my fingers crossed hoping so.  I can't make it happen
> with that patch.

OK, closing.

Thanks,
Rafael
