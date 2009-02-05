Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZBEJ1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZBEJ1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZBEJ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:27:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:44599 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZBEJ1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:27:18 -0500
Subject: Re: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs &
 PowerBooks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
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
In-Reply-To: <20090205000232.GA363@suse.de>
References: <20090204184029.881610776@mini.kroah.org>
	 <20090204184602.GH25246@kroah.com> <1233791475.4612.24.camel@pasglop>
	 <20090205000232.GA363@suse.de>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 20:23:17 +1100
Message-Id: <1233825797.4612.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 16:02 -0800, Greg KH wrote:
> On Thu, Feb 05, 2009 at 10:51:15AM +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2009-02-04 at 10:46 -0800, Greg KH wrote:
> > > plain text document attachment
> > > (fbdev-atyfb-fix-dsp-config-on-some-powermacs-powerbooks.patch)
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > My only possible worry with that one is the first generation clamshell
> > iBook which uses a Mobility M1 chip, for which we haven't had anybody
> > testing whether this would break it or not ... 
> > 
> > So if anybody with such a machine is reading this, please holler...
> 
> But this patch is already in Linus's tree, so why would you worry about
> this?

Oh I always worry about things I can't test ;-) Just felt like
increasing the chances of finding the one or two users still with that
specific machine model :-)

Cheers,
Ben.


