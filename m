Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZDZRp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZDZRp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZDZRpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:45:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZDZRpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:45:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [Bug #13186] cpufreq timer teardown problem
Date: Sun, 26 Apr 2009 19:45:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>, stable@kernel.org
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.X-B._oE9JB@chimera> <20090426162800.GB25774@Krystal>
In-Reply-To: <20090426162800.GB25774@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261945.11690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, Mathieu Desnoyers wrote:
> * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> 
> I've had no news that the patches I proposed has been considered for
> -stable. They fix the teardown problem here. So I guess it's better to
> wait for the patches to get into -stable before we close this bug ?

In fact the bug is closeable as soon as they are in the Linus' tree.  Are they
in it right now?

Thanks,
Rafael
