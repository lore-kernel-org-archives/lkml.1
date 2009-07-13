Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZGMWUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZGMWUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZGMWUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:20:46 -0400
Received: from mail2.shareable.org ([80.68.89.115]:37214 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZGMWUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:20:45 -0400
Date: Mon, 13 Jul 2009 23:20:13 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       David Newall <davidn@davidnewall.com>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090713222013.GB28136@shareable.org>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907102049.12427.Martin@lichtvoll.de> <20090710133127.6839dc87@bike.lwn.net> <200907102240.15773.bzolnier@gmail.com> <20090712112114.GA3059@logfs.org> <alpine.LSU.2.00.0907121324340.13127@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.00.0907121324340.13127@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> On Sunday 2009-07-12 13:21, Jörn Engel wrote:
> >[ Ignoring all legal and moral aspects...]
> >
> >On Fri, 10 July 2009 22:40:14 +0200, Bartlomiej Zolnierkiewicz wrote:
> >> 
> >> Microsoft having patents on their *obsolete* filesystem should be *their*
> >
> >FAT is far from obsolete.  It is practically always the filesystem of
> >choice and often the only filesystem when trying to move data from one
> >system to another.  The next best alternatives are isofs and ext2.  And
> >I don't know a single digital camera, mp3 player or cellphone that
> >speaks either.
> 
> The next best would probably be UDF, which is already used on DVDs
> and thus is implemented in a number of devices - though probably
> only disc-reading ones.
> There's your market hole, dear vendors.

UDF has already been mentioned on this thread, next to "looks usable
in theory, now try it and find out it isn't".

-- Jamie
