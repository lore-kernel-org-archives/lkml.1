Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZJ0ToF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZJ0ToF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZJ0ToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:44:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbZJ0Tny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:43:54 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <22616.1256672350@turing-police.cc.vt.edu>
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
	 <1256671624.26028.419.camel@gandalf.stny.rr.com>
	 <22616.1256672350@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 15:43:24 -0400
Message-Id: <1256672604.26028.421.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:39 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Oct 2009 15:27:04 EDT, Steven Rostedt said:
> > On Tue, 2009-10-27 at 12:06 -0700, Linus Torvalds wrote:
> > >  Don't lie about 
> > > getting an ack that you didn't get before you made that patch public.
> > 
> > But how do you get your ack without making it public?
> 
> I'm going to guess that Linus meant "causing the patch to show up in a
> public git tree" - i.e. shop the patch around on lkml and similar lists a
> bit and get some acked-by's to attach to it *before* it goes out in a tree
> that everybody might pull from.

Yeah, I was being a little facetious there. The rest of my email I was
being serious.

-- Steve


