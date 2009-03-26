Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbZCZQrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbZCZQrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZCZQrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:47:40 -0400
Received: from mail.sl.pt ([212.55.140.13]:49513 "EHLO sl.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752505AbZCZQrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:47:39 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 12:47:38 EDT
Date: Thu, 26 Mar 2009 16:40:53 +0000
From: Jose Celestino <japc@co.sapo.pt>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, mingo@elte.hu, jack@suse.cz,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
	measurements)
Message-ID: <20090326164053.GA6318@co.sapo.pt>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, mingo@elte.hu, jack@suse.cz,
	alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
	drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
	oleg@redhat.com, roland@redhat.com
References: <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326140312.GB14822@elte.hu> <20090326073013.2fa83178.akpm@linux-foundation.org> <200903261632.42439.elendil@planet.nl> <20090326084733.156c4910.akpm@linux-foundation.org> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326163026.GD6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090326163026.GD6239@mit.edu>
X-URL: http://xpto.org/~japc
X-System: Linux morgoth 2.6.28-9-generic
X-UP: 16:26:59 up 1 day, 14:55,  2 users,  load average: 2.45, 1.79, 1.28
X-By: japc@morgoth
X-GPG-key-ID: 0x07B1363B
X-GPG-key-Fingerprint: D3F3 B47B F20C 3B1E 488C B949 1B8B 8141 07B1 363B
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Words by Theodore Tso [Thu, Mar 26, 2009 at 12:30:26PM -0400]:
> On Thu, Mar 26, 2009 at 09:14:28AM -0700, Linus Torvalds wrote:
> > I generally agree witht he "leave policy to user space" people, but this 
> > is an area where (a) user space has shown itself to not get it right (ie 
> > people don't do even the existing relatime because distros don't) and (b) 
> > what's the alternative?
> 
> I thought at least some distro's were adding relatime by default; I
> could be wrong, but I thought Ubuntu was doing this.

Yes.

-- 
Jose Celestino | http://japc.uncovering.org/files/japc-pgpkey.asc
----------------------------------------------------------------
"One man’s theology is another man’s belly laugh." -- Robert A. Heinlein
