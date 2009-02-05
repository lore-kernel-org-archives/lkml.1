Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZBEBCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZBEBCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZBEBCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:02:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:54593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZBEBCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:02:22 -0500
Date: Wed, 4 Feb 2009 16:02:32 -0800
From: Greg KH <gregkh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Subject: Re: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs &
	PowerBooks
Message-ID: <20090205000232.GA363@suse.de>
References: <20090204184029.881610776@mini.kroah.org> <20090204184602.GH25246@kroah.com> <1233791475.4612.24.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233791475.4612.24.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 10:51:15AM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 10:46 -0800, Greg KH wrote:
> > plain text document attachment
> > (fbdev-atyfb-fix-dsp-config-on-some-powermacs-powerbooks.patch)
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> My only possible worry with that one is the first generation clamshell
> iBook which uses a Mobility M1 chip, for which we haven't had anybody
> testing whether this would break it or not ... 
> 
> So if anybody with such a machine is reading this, please holler...

But this patch is already in Linus's tree, so why would you worry about
this?

thanks,

greg k-h
