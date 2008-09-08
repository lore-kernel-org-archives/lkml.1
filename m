Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYIHWUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYIHWUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYIHWUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:20:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:29478 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYIHWUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:20:00 -0400
Date: Mon, 8 Sep 2008 15:19:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSCRIPT] MAINTAINERS: sort and merge P and M fields
Message-Id: <20080908151934.4a361191.randy.dunlap@oracle.com>
In-Reply-To: <20080908221139.GA10991@cassiopeia.tralala>
References: <20080908221139.GA10991@cassiopeia.tralala>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 00:11:39 +0200 Uwe Kleine-König wrote:

> Hello Linus,
> 
> some time ago I sent two patch scripts to LKML that changed the
> MAINTAINERS file.  One fixed the alphabetic ordering and another merged
> the P and M fields to ease copy'n'paste.
> 
> See
> 	http://thread.gmane.org/gmane.linux.kernel/702194
> for the details.
> 
> I still like both changes, but I think it's not sensible to send you the
> resulting patches because MAINTAINERS changes frequently.
> 
> If you like these two changes, too, I would be happy if you run the
> attached script in your working copy.  It simply wraps the two scripts
> and commits the changes.
> 
> Note that you need to apply the patch below before the scripts will
> work.  And note further that the script expects a clean working copy to
> start with, because it uses git commit -a.


I like it.  Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
