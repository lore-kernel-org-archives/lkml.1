Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZGLLWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZGLLWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 07:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZGLLV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 07:21:59 -0400
Received: from lazybastard.de ([212.112.238.170]:33318 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZGLLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 07:21:58 -0400
Date: Sun, 12 Jul 2009 13:21:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Martin Steigerwald <Martin@lichtvoll.de>,
       David Newall <davidn@davidnewall.com>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090712112114.GA3059@logfs.org>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907102049.12427.Martin@lichtvoll.de> <20090710133127.6839dc87@bike.lwn.net> <200907102240.15773.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907102240.15773.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ignoring all legal and moral aspects...]

On Fri, 10 July 2009 22:40:14 +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Microsoft having patents on their *obsolete* filesystem should be *their*

FAT is far from obsolete.  It is practically always the filesystem of
choice and often the only filesystem when trying to move data from one
system to another.  The next best alternatives are isofs and ext2.  And
I don't know a single digital camera, mp3 player or cellphone that
speaks either.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
