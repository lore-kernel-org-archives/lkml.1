Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZBGCyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZBGCyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZBGCyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:54:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:60461 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZBGCyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:54:04 -0500
Subject: Re: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs &
 PowerBooks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Risto Suominen <Risto.Suominen@gmail.com>
In-Reply-To: <1233921904.17724.181.camel@macbook.infradead.org>
References: <20090204184029.881610776@mini.kroah.org>
	 <20090204184602.GH25246@kroah.com>  <1233791475.4612.24.camel@pasglop>
	 <1233921904.17724.181.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 13:50:38 +1100
Message-Id: <1233975038.31963.54.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 12:05 +0000, David Woodhouse wrote:
> On Thu, 2009-02-05 at 10:51 +1100, Benjamin Herrenschmidt wrote:
> > My only possible worry with that one is the first generation clamshell
> > iBook which uses a Mobility M1 chip, for which we haven't had anybody
> > testing whether this would break it or not ... 
> > 
> > So if anybody with such a machine is reading this, please holler...
> 
> I think I have one in the shed. That's a PowerBook1,1?

Nah, I think that's the lombard (black) ... well, iirc, I don't remember
100%, though I can try to find out.

Ben.


