Return-Path: <linux-kernel-owner+w=401wt.eu-S936743AbXGTVmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936743AbXGTVmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbXGTVmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:42:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXGTVl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:41:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Date: Fri, 20 Jul 2007 23:49:53 +0200
User-Agent: KMail/1.9.5
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <46A0210E.6010207@tmr.com> <20070720104215.476f4cc1.randy.dunlap@oracle.com> <20070720175730.GB21550@deepthought>
In-Reply-To: <20070720175730.GB21550@deepthought>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202349.54571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 19:57, Ken Moffat wrote:
> On Fri, Jul 20, 2007 at 10:42:15AM -0700, Randy Dunlap wrote:
> > 
> > man uptime:
> > 	uptime - tell how long the system has been running
> > 
> > I claim that the system is not running when it is suspended,
> > so the suspension time should not be included in uptime.
> > 
>  So, maybe I shouldn't have put corrected in inverted commas,
> because this was a real correction and my previous usage was an
> unintended side-effect of an error.
> 
>  Anyway, the current behaviour is known and I guess any attempt to
> change it (e.g. to what Bill was expecting) won't be well received.

I agree.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
