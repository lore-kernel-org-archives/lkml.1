Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYG1Xmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYG1Xmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYG1Xmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:42:33 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20079 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146AbYG1Xmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:42:32 -0400
Date: Tue, 29 Jul 2008 08:41:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: James Morris <jmorris@namei.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Jon Smirl <jonsmirl@gmail.com>,
       Simon Arlott <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080728234131.GD28055@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	James Morris <jmorris@namei.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Jon Smirl <jonsmirl@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
	lkml <linux-kernel@vger.kernel.org>
References: <488DFD97.7080802@simon.arlott.org.uk> <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com> <488E0BB6.7020006@simon.arlott.org.uk> <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com> <488E1147.5040803@simon.arlott.org.uk> <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com> <20080728141414.d7e5def2.randy.dunlap@oracle.com> <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 08:01:09AM +1000, James Morris wrote:
> On Mon, 28 Jul 2008, Randy Dunlap wrote:
> 
> > It would be Good if we could give more value to Reviewed-by: tag lines also...
> > 
> > IOW, we "need" to do this.  :)
> 
> Also, Tested-by:, to encourage and recognize people who may not be 
> confident in reviewing code to at least test it, which is immensely 
> useful if done thoughtfully.
> 
>   "Measuring programming progress by lines of code is like measuring 
>    aircraft building progress by weight."
> 
> If you know who said this, award yourself a cookie :-)
> 
Or just filter on "-by:", which seems to get anything relevant, including
people that shamelessly make up their own tags. In order for something to
be converted from a Cc: to a *-by: requires manual effort at least, which
ought to be sufficient for recognition.

If someone was really bored they could probably make a table of tags with
various points to try and balance things slightly more objectively.
Though it seems we now at least have totally different metrics on LWN,
for the kernel summit selection process, and Jon's new script. ;-)

Trying to map all of the names seems pretty pointless though, most
regular contributors contribute in a fairly consistent and sane manner,
with the odd mismatch or typo here or there. It might make sense for
anyone where there's a significant difference, but those are going to be
corner cases.
