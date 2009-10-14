Return-Path: <linux-kernel-owner+w=401wt.eu-S934153AbZJNOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbZJNOv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934112AbZJNOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:51:26 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12953 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934109AbZJNOvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:51:25 -0400
From: "Colbert, Rusty" <rusty.colbert@hp.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Oct 2009 14:50:10 +0000
Subject: RE: [PATCH 1/3] edac: Create an unique instance for each kobj
Thread-Topic: [PATCH 1/3] edac: Create an unique instance for each kobj
Thread-Index: AcpMsuJyaF6d0jwHSLuwzGACZ2gEQgAKqM7w
Message-ID: <EC2969A33F12344780D895AFCAA422CE50861619C0@GVW1095EXB.americas.hpqcorp.net>
References: <20090924192821.7fcffc80@pedra.chehab.org>
	<20091004164354.5ff55ea1@pedra.chehab.org>
	<20091013200117.895885a6.akpm@linux-foundation.org>
 <20091014064138.250777cd@pedra.chehab.org>
In-Reply-To: <20091014064138.250777cd@pedra.chehab.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this all into a dev tree, or are there patches for a SLES 11 (2.6.27) ?

-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
Sent: Wednesday, October 14, 2009 4:42 AM
To: Andrew Morton
Cc: Ingo Molnar; bluesmoke-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] edac: Create an unique instance for each kobj

Hi Andrew,

Em Tue, 13 Oct 2009 20:01:17 -0700
Andrew Morton <akpm@linux-foundation.org> escreveu:

> On Sun, 4 Oct 2009 16:43:54 -0300 Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
> > Current code only works when there's just one memory
> > controller, since we need one kobj for each instance.
>
> I don't know which kernel you're patching here, but it doesn't look
> anything like mine...

It is on i7core_edac git tree. This tree were added to linux-next. You'll be
able to see it starting from today's linux-next.

Cheers,
Mauro

------------------------------------------------------------------------------
Come build with us! The BlackBerry(R) Developer Conference in SF, CA
is the only developer event you need to attend this year. Jumpstart your
developing skills, take BlackBerry mobile applications to market and stay
ahead of the curve. Join us from November 9 - 12, 2009. Register now!
http://p.sf.net/sfu/devconference
_______________________________________________
bluesmoke-devel mailing list
bluesmoke-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/bluesmoke-devel
