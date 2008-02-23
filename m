Return-Path: <linux-kernel-owner+w=401wt.eu-S1764478AbYBWDlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764478AbYBWDlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 22:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYBWDlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 22:41:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56792 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbYBWDlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 22:41:07 -0500
Date: Sat, 23 Feb 2008 04:41:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 34/38] kbuild: allow -fstack-protector to take effect
Message-ID: <20080223034115.GA9937@uranus.ravnborg.org>
References: <20080223001946.979768610@mini.kroah.org> <20080223003133.GI7268@suse.de> <20080222164617.50c8ec2e@laptopd505.fenrus.org> <20080223005349.GA30744@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223005349.GA30744@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 04:53:49PM -0800, Greg KH wrote:
> On Fri, Feb 22, 2008 at 04:46:17PM -0800, Arjan van de Ven wrote:
> > On Fri, 22 Feb 2008 16:31:33 -0800
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > 2.6.24-stable review patch.  If anyone has any objections, please let
> > > us know.
> > 
> > 
> > not ready for -stable yet. if ever for backporting (doubtful)
> 
> Ok, dropped from -stable, thanks.

For the record I agree with Arjan that it is not yet -stable ready.

	Sam
