Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYECWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYECWiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYECWiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:38:07 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:40659 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYECWiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:38:05 -0400
Date: Sun, 04 May 2008 00:38:02 +0200
Message-Id: <263952368@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, jgarzik@redhat.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rjw@sisk.pl
Subject: Re: modprobe aha1542 oops with git17
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/O/8qFQ9UHch/myBMVG0XIBSHmSRbacbrZxf2MD3p8Mdk81
 mrCfXg73LM/NdZH2SPsJjAj0Rt9p8GMU1Z8ErXVjUU9i7nrGl0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the pointers !

i`m new to git and i thought i had fetched the latest git (just fetched via http some hours ago) - wondering why my copy doesn`t have that fix.....

will need learn more about git - sorry for the noise

> -----Ursprüngliche Nachricht-----
> Von: "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Gesendet: 04.05.08 00:24:11
> An: devzero@web.de
> CC: akpm@linux-foundation.org, jgarzik@redhat.com, rjw@sisk.pl,  linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Betreff: Re: modprobe aha1542 oops with git17


> On Sat, 2008-05-03 at 22:29 +0200, devzero@web.de wrote:
> > this also happens on real hardware with latest git - no aha1542
> > attached
> > 
> > didn`t happen before - looks like a regression to me
> 
> Actually, if you check with our tool sets:
> 
> http://www.kerneloops.org/search.php?search=scsi_destroy_command_freelist&btnG=Function+Search
> 
> They'll point you to the bugzilla entry:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10598
> 
> And the fix (which is now upstream):
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=61d7416a286e840d905c18b1e6b0977c036c8656
> 
> James
> 
> 
> 


_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

