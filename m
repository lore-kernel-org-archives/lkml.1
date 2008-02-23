Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYBWEEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYBWEEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYBWEEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:04:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43821 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYBWEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:04:06 -0500
Date: Fri, 22 Feb 2008 19:53:56 -0800
From: Greg KH <greg@kroah.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>, jejb@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [stable] [patch 34/38] kbuild: allow -fstack-protector to take
	effect
Message-ID: <20080223035356.GB25980@kroah.com>
References: <20080223001946.979768610@mini.kroah.org> <20080223003133.GI7268@suse.de> <20080222164617.50c8ec2e@laptopd505.fenrus.org> <20080223005349.GA30744@suse.de> <20080223034115.GA9937@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223034115.GA9937@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:41:15AM +0100, Sam Ravnborg wrote:
> On Fri, Feb 22, 2008 at 04:53:49PM -0800, Greg KH wrote:
> > On Fri, Feb 22, 2008 at 04:46:17PM -0800, Arjan van de Ven wrote:
> > > On Fri, 22 Feb 2008 16:31:33 -0800
> > > Greg KH <gregkh@suse.de> wrote:
> > > 
> > > > 2.6.24-stable review patch.  If anyone has any objections, please let
> > > > us know.
> > > 
> > > 
> > > not ready for -stable yet. if ever for backporting (doubtful)
> > 
> > Ok, dropped from -stable, thanks.
> 
> For the record I agree with Arjan that it is not yet -stable ready.

Ok.  Then who sent this to the stable alias in the first place?

Sam, you added the "cc: stable@kernel.org" to the patch, and that caused
it to be sent to us when it went into Linus's tree.  If you don't want
things like this to go into the -stable tree, don't mark it as such :)

thanks,

greg k-h
