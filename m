Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbZBRVuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbZBRVuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbZBRVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:44:39 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:55570 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759474AbZBRVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:44:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAHcPnElMQWt2/2dsb2JhbACBbtNNhBMG
Date: Wed, 18 Feb 2009 16:44:26 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       pierre-marc.fournier@polymtl.ca
Subject: Re: Moving Userspace RCU (urcu) from GPL to LGPL license
Message-ID: <20090218214426.GA30245@Krystal>
References: <20090218180232.GA21389@Krystal> <20090218213448.3b467c88@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090218213448.3b467c88@the-village.bc.nu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:43:51 up 48 days, 21:42,  6 users,  load average: 0.18, 0.33,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> On Wed, 18 Feb 2009 13:02:32 -0500
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> > only thing is that we cannot put GPL code into a LGPL library.
> 
> You'll need a patent grant from IBM for non GPL use for that not just an
> LGPL library
>  
> > The other point is that I use a few low-level primitives from the Linux
> > kernel header (e.g. atomic increment for x86, barrier macros). Those are
> > simple one-liners, but, still, I wonder about the licensing
> > implications. I could simply "rewrite" them, but that would be a shame
> 
> Ask the author - certainly the original basic atomic ops Linus gave
> specific permission to the mozilla folks to use under other licences.
> 
> Alan
> 

Thanks Alan for this precious information. I'll discuss with IBM about
possible alternatives.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
