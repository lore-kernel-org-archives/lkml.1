Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbYDNP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbYDNP4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbYDNPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:55:59 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22717 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758246AbYDNPz5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:55:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Microblaze Linux release
Date: Mon, 14 Apr 2008 08:55:52 -0700
In-reply-to: <4802560D.3020308@seznam.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Microblaze Linux release
Thread-Index: AcidlyjNMgYFh8XrR8eNkbITuVK2OQAsJbdg
References: <48020A21.4000404@seznam.cz> <20080413101304.308f6c1a@zod.rchland.ibm.com> <4802560D.3020308@seznam.cz>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <monstr@seznam.cz>, "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Cc: "John Williams" <john.williams@petalogix.com>, <benh@kernel.crashing.org>,
       "John Linn" <linnj@xilinx.com>, "git-dev" <git-dev@xilinx.com>,
       "Grant Likely" <grant.likely@secretlab.ca>,
       <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>,
       <paulus@samba.org>
X-OriginalArrivalTime: 14 Apr 2008 15:55:53.0345 (UTC) FILETIME=[04AEAF10:01C89E48]
Message-Id: <20080414155554.5B8CD98059@mail51-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Simek [mailto:monstr@seznam.cz]
> Sent: Sunday, April 13, 2008 11:51 AM
> To: Josh Boyer
> Cc: Stephen Neuendorffer; John Williams; benh@kernel.crashing.org;
John Linn; git-dev; Grant Likely;
> git; microblaze-uclinux@itee.uq.edu.au; linux-kernel@vger.kernel.org;
paulus@samba.org
> Subject: Re: Microblaze Linux release
> 
> Hi Josh,
> 
> >> Hi Everybody,
> >>
> >> I fixed all reported bugs which I got from LKML and from you.
> >> Latest version of Microblaze Linux kernel is available at
git.monstr.eu.
> >> There is git repository called linux-microblaze.git
> >> Microblaze port is based on 2.6.24-rc5. I'll create the new repo
with clean pack
> >> of changes based on latest kernel version for easier pull.
> >>
> >> Merge windows will be open hopefully next week and I would like to
send pull
> >> request to Paul.
> >
> > Why Paul?  If microblaze is a new architecture (which it seems to
be),
> > then you should really work through Linus directly.
> 
> I don't know who start with it. For me is not this point important.
> I think that was Steve's idea, wasn't it?

Nope, it should go through Linus.  My hope was to recruit reviewers from
the powerpc community, since there is alot of overlap (device trees,
drivers, the MMU is very similar).

Steve

