Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZDKS6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZDKS6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZDKS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:58:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbZDKS6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:58:20 -0400
Date: Sat, 11 Apr 2009 21:00:37 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken
	and (minor but annoying) audio problem
Message-ID: <20090411190037.GA5230@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain> <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18Zdi2FO8CqT8ANAPvISeTyBhSXWlVBZH9R0cC
 Tc2NSdpgNLZVvdz5QHmE82mjpN2/2groUmwfyeP/LprMA7iUBB
 6kyzCRjoLn6odHBiZgtlsKDlcvMjw4Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.04.2009, Linus Torvalds wrote: 

[Len Brown:]
> > fastboot also causes the S3 regression here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12936
 
> Looks like the same issue. Does my one-liner fix that case too?

http://bugzilla.kernel.org/show_bug.cgi?id=13063

Your one-liner fixes this bug, too. Without the revertion mentioned in the
bugreport applied!

Regards,
Heinz.
