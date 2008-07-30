Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYG3QmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYG3QmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYG3QmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:42:14 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56140 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080AbYG3QmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:42:14 -0400
Date: Wed, 30 Jul 2008 12:40:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jon Smirl <jonsmirl@gmail.com>, davids@webmaster.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080730164056.GB8283@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Jon Smirl <jonsmirl@gmail.com>,
	davids@webmaster.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <4890284E.3050806@s5r6.in-berlin.de> <MDEHLPKNGKAHNMBLJOLKAEDIOJAC.davids@webmaster.com> <20080730155359.7c0206f4@lxorguk.ukuu.org.uk> <9e4733910807300823x516eb45dx877898f9d7c8be57@mail.gmail.com> <20080730161408.4dfa6fe8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730161408.4dfa6fe8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 04:14:08PM +0100, Alan Cox wrote:
> > > The GPL doesn't trump data protection law. It can't.
> > 
> > By making a submission to a GPL'd project didn't you grant a license
> > for your data to be used? That was Ted's point when he posted the
> > developer's certification.
> 
> Data protection law trumps the GPL. The fact my address is public does
> not give you the rights globally to process it.

Yes, but when you submit patches using the required Signed-off-by:,
you are agreeing to the following from the Developer's Certification
of Origin:

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

How this interacts with Europe's Data Protection Law, and whether
correcting spelling errors in e-mail addresses to make it easier to
canonicalize the list is consistent with what is allowed by the GPL,
Europe's Data Protection Law, and the permission given when a
developer's signs the DCO's, is probably not worth debating on LKML.
Let someone file a complaint with the EU who can try to arrest Jon
Smirl the next time he enters Europe, or get him extadicted to the
Hague for violations against international law if they really think
they can justify it, argue about whether they can do so in other
forums; if you put a beer in my hand, maybe I'd even be willing to
debate it in a bar at some future conference.  But does it really make
sense to argue about it here?

						- Ted

