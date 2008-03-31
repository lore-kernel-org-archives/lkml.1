Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYCaK2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYCaK2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYCaK2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:28:05 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2850 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYCaK2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:28:04 -0400
Date: Mon, 31 Mar 2008 12:28:52 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jarod Wilson <jwilson@redhat.com>, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080331102852.GJ28821@deprecation.cyrius.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <200803302106.42624.jwilson@redhat.com> <alpine.LFD.1.10.0803311217550.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0803311217550.3219@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2008-03-31 12:19]:
> > >      Board: PM965/GM965/GL960 based
> > >      The R5C832 is known to work with ohci1394 according to
> > >      http://hardware4linux.info/component/14348/ and other reports.
> > 
> > Its also known to work with the juju firewire stack -- that's the controller 
> > in my own laptop, as well as a few other folks here in the office, all 
> > running the new stack.
> 
> Hmm, can you please check whether you can reproduce the problem with
> the original stack ?

I get virtually the same message with the old and new stack.
-- 
Martin Michlmayr
http://www.cyrius.com/
