Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYHQV6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYHQV6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 17:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYHQV6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 17:58:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYHQV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 17:58:23 -0400
Date: Sun, 17 Aug 2008 23:58:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: rmeijer@xs4all.nl, Peter Dolding <oiaohm@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Message-ID: <20080817215822.GA21112@atrey.karlin.mff.cuni.cz>
References: <6746.82.95.100.23.1218969200.squirrel@webmail.xs4all.nl> <alpine.DEB.1.10.0808170345300.12859@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808170345300.12859@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>you are arguing with the wrong people here. we are not trying to define
> >>the future of anti-virus technologies, we are trying to figure out how to
> >>provide the hooks so that people and companies can go off and do the
> >>research and experimentation and try different approaches.
> >
> >Given recent demonstrations that show how easy it apparently is to bypass
> >blacklist base approaches, providing hooks to allow these blacklist
> >approaches may I feel be rather futile. Focusing only on hooks for white
> >list approaches in combination with hooks for least authority approaches
> >like the powerbox would IMHO seem like a much more reasonable approach
> >given the current state of things and knowledge concerning the blacklist
> >technologies. Explicitly adding support for technology that is quickly
> >becoming obsolete would seem like a waste of time and resources.
> 
> we are not providing hooks for blacklists or whitelists, we are providing 
> hooks for scanning. it's up to the software that doesn the scanning to 
> implement the blacklist or whitelist.

Actually, I don't think so.

If we wanted to whitelist permitted binaries, approach would be
something like "lets sign them"... and it seems IBM is working on
something like that with TPM infrastructure.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
