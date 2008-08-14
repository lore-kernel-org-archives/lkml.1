Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbYHNShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbYHNShj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYHNSha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:37:30 -0400
Received: from mail15.ca.com ([208.232.182.54]:16010 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYHNSh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:37:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Date: Thu, 14 Aug 2008 14:37:27 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
In-Reply-To: <20080814125410.GA2262@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Thread-Index: Acj+PNKFJPScFTSjQ6yE2UXNi0NwbQ==
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Pavel Machek" <pavel@suse.cz>, <tvrtko.ursulin@sophos.com>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Adrian Bunk" <bunk@kernel.org>,
       <davecb@sun.com>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       "Mihai Don??u" <mdontu@bitdefender.com>
X-OriginalArrivalTime: 14 Aug 2008 18:37:27.0624 (UTC) FILETIME=[CD51C480:01C8FE3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@suse.cz]
> Sent: Thursday, August 14, 2008 8:54 AM
> To: tvrtko.ursulin@sophos.com
> Cc: Arjan van de Ven; Adrian Bunk; davecb@sun.com; Greg KH; Press,
Jonathan;
> linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org;
malware-
> list@lists.printk.net; Mihai Don??u
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
alinuxinterfaceforon access
> scanning
> 
> Hi!
> 
> Okay, so goal of libmalware.so is to "not allow data in the black list
> to pass through Linux server". Threat model is windows machines trying
> to copy infected files through the server. 

That's only part of the threat model.

> Viruses are not expected to have shell access to either root or normal

> users on the server.

That's a big exception.


> it actually _works_, 100% of time, for apps using it.

Again that's a big condition.


Jon Press
