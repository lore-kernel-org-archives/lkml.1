Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbXFRNXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbXFRNXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761314AbXFRNXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:23:46 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:40787 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758260AbXFRNXq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:23:46 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: How to improve the quality of the kernel?
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 18 Jun 2007 09:23:20 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20070617220927.99ebc1ee.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to improve the quality of the kernel?
Thread-Index: AcexZxXwc0Dl4DUXTQyz3WTOMoLGagAQyo+w
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org><200706172053.41806.bzolnier@gmail.com><20070617115258.1f55b29d.akpm@linux-foundation.org><200706172349.08813.bzolnier@gmail.com><4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jun 2007 13:23:20.0942 (UTC) FILETIME=[D71610E0:01C7B1AB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Andrew Morton
> 
> On Mon, 18 Jun 2007 01:15:15 +0200 Stefan Richter 
> <stefanr@s5r6.in-berlin.de> wrote:
> 
> > Tested-by
> 
> Tested-by would be good too.  Because over time, we will 
> generate a list of people who own the relevant hardware and 
> who are prepared to test changes. 

Why not include a user-space tool that, when invoked, if you agree to
send personnal info, sends your hardware vs driver info to a web
database + your email address (maybie even you .config, etc..) ... In
case of help for testing new patches/finding a bug/etc.. your email
could be used by maintainers to ask for help...

> So if you make changes to random-driver.c you can do `git-log 
> random-driver.c|grep Tested-by" to find people who can test 
> your changes for you.

You would'nt even need to search in GIT.  Maybie even when ever a
patchset is being proposed a mail could be sent to appropriate
hardware/or feature pseudo-auto-generated mailing-list?

On lkml I mostly try to follow patches/bugs associated with hardware I
use.  Why not try to automate the process and get more testers in?

- vin
