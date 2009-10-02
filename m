Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZJBVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZJBVab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZJBVaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:30:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36675 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZJBVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:30:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nix <nix@esperi.org.uk>
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported MTU setting'
Date: Fri, 2 Oct 2009 23:31:35 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Duyck" <alexander.duyck@gmail.com>,
       Network Development <netdev@vger.kernel.org>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.jd.5MTxKB@chimera> <877hvd8rj5.fsf@spindle.srvr.nix>
In-Reply-To: <877hvd8rj5.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910022331.35916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Nix wrote:
> On 1 Oct 2009, Rafael J. Wysocki stated:
> 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> 
> The patch fixes it.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14261
> > Subject		: e1000e jumbo frames no longer work: 'Unsupported MTU setting'
> > Submitter	: Nix <nix@esperi.org.uk>
> > Date		: 2009-09-26 11:16 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125396433321342&w=4
> > Handled-By	: Alexander Duyck <alexander.duyck@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/50277/
> 
> (Possibly a stable candidate? It's not in 2.6.31.2-to-be, perhaps the
> only patch that isn't. ;) )

Most likely because it's not in the Linus' tree yet.

[e1000e maintainers, we have a regression fix to merge, please.]

Thanks,
Rafael
