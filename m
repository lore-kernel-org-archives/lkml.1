Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbXFRRur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbXFRRur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbXFRRui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:50:38 -0400
Received: from mx2.math.uh.edu ([129.7.128.33]:35274 "EHLO mx2.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbXFRRuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:50:37 -0400
X-Greylist: delayed 1840 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 13:50:37 EDT
To: Magnus Naeslund <mag@kite.se>
Cc: Theodore Tso <tytso@mit.edu>, "Robert P. J. Day" <rpjday@mindspring.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be) free space left
References: <4676679E.5040901@kite.se>
	<Pine.LNX.4.64.0706180730320.14972@localhost.localdomain>
	<4676787F.30609@kite.se> <20070618134413.GC30244@thunk.org>
	<4676B298.4080904@kite.se>
From: Jason L Tibbitts III <tibbs@math.uh.edu>
Date: 18 Jun 2007 12:19:54 -0500
In-Reply-To: <4676B298.4080904@kite.se>
Message-ID: <ufawsy1kwn9.fsf@epithumia.math.uh.edu>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "MN" == Magnus Naeslund <mag@kite.se> writes:

MN> Inode count: 1430528

That's stunningly small; I created an 8TB partition here and made an
ext3 filesystem in it with the default parameters; I got nearly 1000
times as many inodes as you have:

Inode count:              1072414720
Block count:              2144799744

 - J<
