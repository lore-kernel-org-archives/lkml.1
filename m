Return-Path: <linux-kernel-owner+w=401wt.eu-S2992481AbXDELNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992481AbXDELNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992486AbXDELNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:13:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37066 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992481AbXDELNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:13:22 -0400
Date: Thu, 5 Apr 2007 13:14:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
Message-ID: <20070405111407.GA11705@uranus.ravnborg.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <24083.1175650554@turing-police.cc.vt.edu> <20070403192004.986b44ec.randy.dunlap@oracle.com> <4963.1175654767@turing-police.cc.vt.edu> <46131D86.4070607@oracle.com> <10023.1175709308@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10023.1175709308@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:55:08PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 Apr 2007 20:37:42 PDT, Randy Dunlap said:
> >
> > Good luck.  But the symbols are there.  Just use left/right arrow keys
> > to scroll the display left/right and you can see them.  Now if you just
> > had that indicator to tell you that you Need to scroll to see more text...
> 
> Exactly. :)  I had the incredible bad luck that the line got cut off at the
> end of a CONFIG_ symbol that made sense - if it had showed up *half* a symbol,
> I'd have gone investigating. ;) (Even a '>' or '<' saying data offscreen to
> right or left would be sufficient, if somebody wants a small but productive
> kernel (config system actually) task to hack on.)
> 
> I'd code it myself, but I have an SL8500 to install, and need to figure out
> how my laptop made it into the bag this morning still up and running (I hit
> the power button, it seemed to power down - blank screen, power light off,
> but syslog msgs prove it was up and running for another 4 hours before it
> shut down on a thermal check...)

If you do not find time to do it try to ping me in a week or so.
Should be trivial to do but away from my dev box atm.

   Sam
