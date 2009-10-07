Return-Path: <linux-kernel-owner+w=401wt.eu-S934363AbZJGSfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363AbZJGSfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934349AbZJGSfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:35:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:59738 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350AbZJGSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:35:45 -0400
Date: Wed, 7 Oct 2009 14:34:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nix <nix@esperi.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Duyck <alexander.duyck@gmail.com>,
       Network Development <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported
	MTU setting'
Message-ID: <20091007183453.GD12971@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Nix <nix@esperi.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Network Development <netdev@vger.kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	e1000-devel@lists.sourceforge.net
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.jd.5MTxKB@chimera> <877hvd8rj5.fsf@spindle.srvr.nix> <200910022331.35916.rjw@sisk.pl> <9929d2390910021513t51827031k16a5bfc538640cbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9929d2390910021513t51827031k16a5bfc538640cbf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 03:13:07PM -0700, Jeff Kirsher wrote:
> >> > Patch               : http://patchwork.kernel.org/patch/50277/
> >>
> > Most likely because it's not in the Linus' tree yet.
> >
> > [e1000e maintainers, we have a regression fix to merge, please.]
>
> Sorry, I forgot to send this patch out last night.  I will send it now.

Do we have a status on this progress of this patch to mainline?   Thanks,

      	     	       	    	     	- Ted
