Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYHHL6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYHHL6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYHHL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:58:30 -0400
Received: from mail15.ca.com ([208.232.182.54]:47750 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbYHHL63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:58:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux	interface	for on access scanning
Date: Fri, 8 Aug 2008 07:58:28 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4B37@USILMS12.ca.com>
In-Reply-To: <489BB5BE.20602@keyaccess.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linux	interface	for on access scanning
Thread-Index: Acj5AlYhGlOKhVRKSYyUuN2EqiWwAQASZavg
References: <20080804223249.GA10517@kroah.com>	<1217896374.27684.53.camel@localhost.localdomain>	<20080805005132.GA3661@kroah.com>	<20080805122328.69a37c1d@lxorguk.ukuu.org.uk>	<20080805170307.GB9639@kroah.com>	<1217962602.27684.144.camel@localhost.localdomain>	<20080805203007.GB27489@kroah.com>	<1218048597.27684.276.camel@localhost.localdomain>	<20080806210202.GA9413@mit.edu>	<1218058081.5837.49.camel@localhost.localdomain>	<20080806215244.GA21462@mit.edu>	<1218118603.5837.101.camel@localhost.localdomain>	<489BAA25.3030004@keyaccess.nl><1218161738.5837.218.camel@localhost.localdomain> <489BB5BE.20602@keyaccess.nl>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>, "Eric Paris" <eparis@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       <malware-list@lists.printk.net>
X-OriginalArrivalTime: 08 Aug 2008 11:58:29.0136 (UTC) FILETIME=[1263E100:01C8F94E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of Rene Herman
> Sent: Thursday, August 07, 2008 10:56 PM
> To: Eric Paris
> Cc: linux-kernel@vger.kernel.org; Alan Cox;
malware-list@lists.printk.net
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
interface for on
> access scanning
> 
> The difference here is just that Linux systems are particularly bad at
> those tasks to begin with which in nice circular motions keeps those
> clueless users away, obviating the need to protect ourselves from
them.
> If this stuff is to be discussed in a context as if Linux were
relevant
> on the desktop though, I believe it's rather unproductive to expect a
> fundamental difference with Windows in this respect.

Just an observation about this...

Since I earn my living on the basis of users, clueless or not, I've
gotten into the habit of just taking them as they come and trying to go
out of my way to not refer to them as clueless -- except in a few
specific and particularly annoying cases.

But that's not my point.  My point is that Linux has become a
commercially viable environment with a lot of enterprise users, with a
significant number of enterprises are standardizing on it, or at least
officially supporting/allowing/encouraging its use.  Because of that,
for example, we have a significant number of user issues coming in that
indicate that there are actually plenty of clueless Linux users, whether
the OS was intended for them or not.

The fact that they are there is the main reason that Red Hat and Novell,
for example (at least by my observation from the outside -- I can't
speak at all about how they see if from the inside) seem to be putting
the bulk of their efforts into their enterprise editions, as opposed to
their traditional technologist editions.

The bottom line, then, is that there ARE way more clueless Linux users
out there than there used to be, which makes them a) vulnerable to
losses by virtue of their own mistakes, and b) vectors for the spread of
malware.  Which is kind of why we're here.


Jon Press

