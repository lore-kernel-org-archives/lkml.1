Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZGMWcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZGMWcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZGMWcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:32:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46644 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZGMWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:32:11 -0400
Date: Tue, 14 Jul 2009 00:32:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jamie Lokier <jamie@shareable.org>
cc: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
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
In-Reply-To: <20090713222013.GB28136@shareable.org>
Message-ID: <alpine.LSU.2.00.0907140022170.1411@fbirervta.pbzchgretzou.qr>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907102049.12427.Martin@lichtvoll.de> <20090710133127.6839dc87@bike.lwn.net> <200907102240.15773.bzolnier@gmail.com> <20090712112114.GA3059@logfs.org> <alpine.LSU.2.00.0907121324340.13127@fbirervta.pbzchgretzou.qr>
 <20090713222013.GB28136@shareable.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-07-14 00:20, Jamie Lokier wrote:
>> The next best would probably be UDF, which is already used on DVDs
>> and thus is implemented in a number of devices - though probably
>> only disc-reading ones.
>> There's your market hole, dear vendors.
>
>UDF has already been mentioned on this thread, next to "looks usable
>in theory, now try it and find out it isn't".
>

Sorry if I was showing a lack of enthusiasm discussing, let alone
reading, the legalese subthreads.
Please do not expect everybody to follow LKML as close as akpm/jcm.

The fact that people even dropped the mailing list from Cc on a
subthread effectively rendered my ~/.procmailrc sort-to-folder rules
useless so that I just decided to hit Thread-Delete to get rid of it
from the master INBOX.

-jeng
