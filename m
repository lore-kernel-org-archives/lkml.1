Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbYDHVJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbYDHVJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYDHVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:09:10 -0400
Received: from jabberwock.ucw.cz ([89.250.246.4]:37230 "EHLO jabberwock.ucw.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYDHVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:09:09 -0400
Date: Tue, 8 Apr 2008 22:36:21 +0200
From: Martin Mares <mj@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, Dan Noe <dpn@isomerica.net>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] e1000e broke e1000
Message-ID: <mj+md-20080408.203606.10380.albireo@ucw.cz>
References: <47F69965.7030303@intel.com> <20080408083606.GA20863@elte.hu> <47FB9ABB.9080403@intel.com> <20080408183921.GA20803@elte.hu> <36D9DB17C6DE9E40B059440DB8D95F5204E2A55C@orsmsx418.amr.corp.intel.com> <20080408195949.GB28148@elte.hu> <20080408200417.GI11962@parisc-linux.org> <47FBD1AD.1080700@isomerica.net> <20080408202003.GJ11962@parisc-linux.org> <20080408203507.GB28952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408203507.GB28952@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You need to upgrade to a more recent version of lspci -- it already 
> > does this ;-)
> 
> yes, but it does not (yet) display the negative condition and the reason 
> for that. (if the kernel knows the reason - and in most cases it knows 
> it)

Yes, it would be nice to have.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Noli tangere fila metalica, ne in solum incasa quidem.
