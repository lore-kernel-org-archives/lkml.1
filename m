Return-Path: <linux-kernel-owner+w=401wt.eu-S1763760AbZE3VHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763760AbZE3VHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 17:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbZE3VHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 17:07:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbZE3VHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 17:07:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Subject: Re: 2.6.30-rc7: Reported regressions 2.6.28 -> 2.6.29
Date: Sat, 30 May 2009 23:07:53 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>
References: <cFumJ-4vi-3@gated-at.bofh.it> <4A20F130.8010903@gmail.com>
In-Reply-To: <4A20F130.8010903@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905302307.53461.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 May 2009, Niel Lambrechts wrote:
> Rafael J. Wysocki wrote:
> > This message contains a list of some regressions introduced between 2.6.28 and
> > 2.6.29, for which there are no fixes in the mainline I know of.  If any of them
> > have been fixed already, please let me know.
> <snip>
> > Please let me know if there are any Bugzilla entries that should be added to
> > the list in there.
> 
> Hi Rafael,
> 
> Can you please add http://bugzilla.kernel.org/show_bug.cgi?id=13017
> 
> This relates to resume issues that lead to EXT4 file-system errors, with symptoms being ATA bus errors.

It's already in the list of regressions introduced between 2.6.28 and 2.6.29.

Thanks,
Rafael
