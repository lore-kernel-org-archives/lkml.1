Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYI3OKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYI3OKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYI3OJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:09:54 -0400
Received: from khc.piap.pl ([195.187.100.11]:40857 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYI3OJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:09:53 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	<alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	<alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 30 Sep 2008 16:09:50 +0200
In-Reply-To: <alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz> (Jiri Kosina's message of "Tue\, 30 Sep 2008 09\:06\:33 +0200 \(CEST\)")
Message-ID: <m3d4ilk9n5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> So far it seems to be that you need 1) something close to xorg 7.4 and 
> 2) 2.6.27-rcX kernel to trigger it. Not every system having e1000e is 
> affected.

And this e1000e must be ICH*, right? I.e. not a separate e1000e
chip/card?
-- 
Krzysztof Halasa
