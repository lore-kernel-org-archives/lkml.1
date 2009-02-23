Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZBWQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZBWQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZBWQ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:57:04 -0500
Received: from kroah.org ([198.145.64.141]:32923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783AbZBWQ5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:57:03 -0500
Date: Mon, 23 Feb 2009 08:54:32 -0800
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       bugme-daemon@bugzilla.kernel.org, stable@kernel.org
Subject: Re: [stable] [Bug #12610] sync-Regression in 2.6.28.2?
Message-ID: <20090223165432.GA5053@kroah.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.xTF.As0lJB@chimera> <20090221175646.GB3750@mit.edu> <200902221102.10579.rjw@sisk.pl> <20090223043536.GC19687@suse.de> <20090223053736.GC19739@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223053736.GC19739@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:37:36AM -0500, Theodore Tso wrote:
> On Sun, Feb 22, 2009 at 08:35:36PM -0800, Greg KH wrote:
> > 
> > Ted, can you forward the needed patches to stable@kernel.org, or just
> > tell us to take those git commits directly?
> > 
> 
> Already in the for-stable and for-stable-2.6.27 branches of the ext4
> git tree.  I was going to see if some folks would do some quick
> testing (even though it it was mostely a straightforward git
> cherry-pick) before sending it to stable@kernel.org; you should see
> them in 2-3 days or so.  If you need them sooner, I can accelerate
> when I push them to you....

Sooner would be good, want to get another review cycle started tomorrow.

But if you miss it, it'll only be a week or so until the next cycle :)

thanks,

greg k-h
