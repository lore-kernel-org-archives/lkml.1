Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYBXOr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYBXOr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYBXOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:47:16 -0500
Received: from khc.piap.pl ([195.187.100.11]:56955 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYBXOrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:47:15 -0500
To: =?iso-8859-2?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Newall <davidn@davidnewall.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
	<47BE2985.6020305@davidnewall.com>
	<20080222020615.GE27894@ZenIV.linux.org.uk>
	<m3myptsp8u.fsf@maximus.localdomain>
	<20080222031315.GF27894@ZenIV.linux.org.uk>
	<m38x1c4od1.fsf@maximus.localdomain>
	<20080224074730.GB31293@lazybastard.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 24 Feb 2008 15:47:12 +0100
In-Reply-To: <20080224074730.GB31293@lazybastard.org> (=?iso-8859-2?Q?=22J?=
 =?iso-8859-2?Q?=F6rn?= Engel"'s message of "Sun\, 24 Feb 2008 08\:47\:31
 +0100")
Message-ID: <m3ir0ebedr.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> I strongly disagree.  Machine-generated warnings are a great way of
> quickly locating a large amount of questionable code in an otherwise
> overwhelming haystack.  It doesn't even matter much, which warnings you
> look for.  Almost all code checkers find the same hotspots.

I think you misunderstood. Of course I'm not against warnings in
general. I'm rather talking about _authority_ of human vs machine,
in this specific ("measuring" code complexity) case.
-- 
Krzysztof Halasa
