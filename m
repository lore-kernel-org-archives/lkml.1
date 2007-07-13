Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbXGMMi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbXGMMi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbXGMMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:38:46 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:37491 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXGMMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:38:45 -0400
Subject: Re: Documentation of kernel messages (Summary)
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
       Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
In-Reply-To: <20070713115321.23e3544f@the-village.bc.nu>
References: <E1I7wsz-0007oJ-DE@w-gerrit.beaverton.ibm.com>
	 <200707101212.38981.rob@landley.net> <1184163990.23373.46.camel@Gundam>
	 <200707111413.03513.rob@landley.net> <20070711213234.GE19456@thunk.org>
	 <20070713115321.23e3544f@the-village.bc.nu>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Fri, 13 Jul 2007 20:49:00 +0800
Message-Id: <1184330940.23373.70.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2007 12:38:34.0649 (UTC) FILETIME=[BA420890:01C7C54A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 11:53 +0100, Alan Cox wrote:
> > One thing that would be a VERY good idea is to make sure that each
> > translated document is tagged with when it was last translated, and
> > against which kernel version (using either a GIT commit id or a
> 
> The English versions need a last updated too, that way we would know when
> they are past their best before date (as most of them are)

Good idea.  So a "last updated" date field will be required for both the
English and translated documents.  Date will be more straight forward
than using commit id, IMHO.

- Leo

