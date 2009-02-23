Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZBWFh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZBWFh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 00:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBWFht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 00:37:49 -0500
Received: from thunk.org ([69.25.196.29]:50807 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZBWFhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 00:37:48 -0500
Date: Mon, 23 Feb 2009 00:37:36 -0500
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       bugme-daemon@bugzilla.kernel.org, stable@kernel.org
Subject: Re: [Bug #12610] sync-Regression in 2.6.28.2?
Message-ID: <20090223053736.GC19739@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Federico Cuello <fedux@lugmen.org.ar>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	bugme-daemon@bugzilla.kernel.org, stable@kernel.org
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.xTF.As0lJB@chimera> <20090221175646.GB3750@mit.edu> <200902221102.10579.rjw@sisk.pl> <20090223043536.GC19687@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223043536.GC19687@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 08:35:36PM -0800, Greg KH wrote:
> 
> Ted, can you forward the needed patches to stable@kernel.org, or just
> tell us to take those git commits directly?
> 

Already in the for-stable and for-stable-2.6.27 branches of the ext4
git tree.  I was going to see if some folks would do some quick
testing (even though it it was mostely a straightforward git
cherry-pick) before sending it to stable@kernel.org; you should see
them in 2-3 days or so.  If you need them sooner, I can accelerate
when I push them to you....

					- Ted
