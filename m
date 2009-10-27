Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZJ0T1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZJ0T1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbZJ0T1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:27:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbZJ0T1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:27:11 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <alpine.LFD.2.01.0910271200060.31845@localhost.localdomain>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au>
	 <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>
	 <20091023123555.GA25366@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
	 <20091023134115.GD27097@elte.hu>
	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
	 <20091023191631.GA1879@elte.hu>
	 <1256326512.26028.34.camel@gandalf.stny.rr.com>
	 <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu>
	 <4AE2F0F6.30909@s5r6.in-berlin.de>
	 <alpine.LFD.2.01.0910271200060.31845@localhost.localdomain>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 15:27:04 -0400
Message-Id: <1256671624.26028.419.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 12:06 -0700, Linus Torvalds wrote:
>  Don't lie about 
> getting an ack that you didn't get before you made that patch public.

But how do you get your ack without making it public?

But I do agree Signed-off-by is a must for every commit (if one is
missing, something is horribly broken). When I need an Acked-by
(touching a maintainer's code) I post an RFC branch (not to be pulled).

But for Tested-by, it is much easier for a tester to pull and test some
git branch than it is to pull patches from LKML.

And as we know, the easier it is to test, the more testers we have.

-- Steve


