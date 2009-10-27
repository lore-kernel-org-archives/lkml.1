Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZJ0TkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZJ0TkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZJ0TkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:40:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42354 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZJ0TkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:40:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: rostedt@goodmis.org
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
Subject: Re: [RFC] to rebase or not to rebase on linux-next
In-Reply-To: Your message of "Tue, 27 Oct 2009 15:27:04 EDT."
             <1256671624.26028.419.camel@gandalf.stny.rr.com>
From: Valdis.Kletnieks@vt.edu
References: <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <4AE2F0F6.30909@s5r6.in-berlin.de> <alpine.LFD.2.01.0910271200060.31845@localhost.localdomain>
            <1256671624.26028.419.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256672350_3649P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 15:39:10 -0400
Message-ID: <22616.1256672350@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AE74C60.01E8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256672350_3649P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Oct 2009 15:27:04 EDT, Steven Rostedt said:
> On Tue, 2009-10-27 at 12:06 -0700, Linus Torvalds wrote:
> >  Don't lie about 
> > getting an ack that you didn't get before you made that patch public.
> 
> But how do you get your ack without making it public?

I'm going to guess that Linus meant "causing the patch to show up in a
public git tree" - i.e. shop the patch around on lkml and similar lists a
bit and get some acked-by's to attach to it *before* it goes out in a tree
that everybody might pull from.

--==_Exmh_1256672350_3649P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK50xecC3lWbTT17ARAhk+AJ4icIIWf85kIc3+uhlBFCILhI1QGQCePBfe
FlIFcL6CopHrK7LPYJwwqQE=
=zdqE
-----END PGP SIGNATURE-----

--==_Exmh_1256672350_3649P--

