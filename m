Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZGLL1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZGLL1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZGLL1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:27:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZGLL1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:27:11 -0400
Date: Sun, 12 Jul 2009 13:27:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
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
In-Reply-To: <20090712112114.GA3059@logfs.org>
Message-ID: <alpine.LSU.2.00.0907121324340.13127@fbirervta.pbzchgretzou.qr>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907102049.12427.Martin@lichtvoll.de> <20090710133127.6839dc87@bike.lwn.net> <200907102240.15773.bzolnier@gmail.com> <20090712112114.GA3059@logfs.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-07-12 13:21, Jörn Engel wrote:
>[ Ignoring all legal and moral aspects...]
>
>On Fri, 10 July 2009 22:40:14 +0200, Bartlomiej Zolnierkiewicz wrote:
>> 
>> Microsoft having patents on their *obsolete* filesystem should be *their*
>
>FAT is far from obsolete.  It is practically always the filesystem of
>choice and often the only filesystem when trying to move data from one
>system to another.  The next best alternatives are isofs and ext2.  And
>I don't know a single digital camera, mp3 player or cellphone that
>speaks either.

The next best would probably be UDF, which is already used on DVDs
and thus is implemented in a number of devices - though probably
only disc-reading ones.
There's your market hole, dear vendors.
