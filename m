Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZF2XUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZF2XUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZF2XT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:19:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687AbZF2XT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:19:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Smolik <marvin@mydatex.cz>
Subject: Re: [Bug #13512] D43 on 2.6.30 doesn't suspend anymore
Date: Tue, 30 Jun 2009 01:20:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.uzF.njASKB@chimera> <4A485D71.5020204@mydatex.cz>
In-Reply-To: <4A485D71.5020204@mydatex.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300120.33817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Daniel Smolik wrote:
> Rafael J. affected napsal(a):
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13512
> > Subject		: D43 on 2.6.30 doesn't suspend anymore
> > Submitter	: Daniel Smolik <marvin@mydatex.cz>
> > Date		: 2009-06-11 20:12 (18 days old)
> >
> >
> >   
> Yes problem still exists. I now bitsecting and I am near to find 
> affected patch.

Thanks for the update.

Best,
Rafael
