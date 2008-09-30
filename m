Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYI3OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYI3OLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYI3OLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:11:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:38254 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753522AbYI3OLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:11:06 -0400
Date: Tue, 30 Sep 2008 16:11:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <m3d4ilk9n5.fsf@maximus.localdomain>
Message-ID: <alpine.LNX.1.10.0809301610300.4022@jikos.suse.cz>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz>
 <m3d4ilk9n5.fsf@maximus.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Krzysztof Halasa wrote:

> > So far it seems to be that you need 1) something close to xorg 7.4 and 
> > 2) 2.6.27-rcX kernel to trigger it. Not every system having e1000e is 
> > affected.
> And this e1000e must be ICH*, right? I.e. not a separate e1000e
> chip/card?

So far all the affected systems I am aware of were ICH.

-- 
Jiri Kosina
SUSE Labs
