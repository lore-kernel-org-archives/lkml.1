Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbYA2Pjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbYA2Pjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYA2PjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:39:25 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:49872 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbYA2PjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QCpj+SQj0VXRENBbfgcv6PqdFg3L++kgwjJzppA1h3IyEhHfbDB8dLitxwuaOBtzuIMiyMs9xwIUtL1aUEh7wOQODw3ddMMydldgQ6xW58vqQZSPyn4pHy+tpcYskYdCo73QXWXp8CHaiSSAkbkLiT/YaTMwlhPt3YPV8bzoxcw=
Message-ID: <87f94c370801290739t39640bf5w960576ae4b273156@mail.gmail.com>
Date: Tue, 29 Jan 2008 10:39:21 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>, "Philipp Thomas" <pth@suse.de>
Subject: Make_bad_sector
Cc: "Gene Heskett" <gene.heskett@gmail.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux ide Mailing list" <linux-ide@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 3:43 PM, Mark Lord <lkml@rtr.ca> wrote:
> Gene Heskett wrote:
> > On Monday 28 January 2008, Mark Lord wrote:
> >..
> >> Another way is to use the "make_bad_sector" utility that
> >> is included in the source tarball for hdparm-7.7, as follows:
> >>
> >>   make_bad_sector --readback /dev/sda 474507
> >>
> > Apparently not in the rpm, darnit.
> ..
>
> That's okay.  It should still be in the SRPM source file.
> And it's a tiny download from sourceforge.net:
>
> http://sourceforge.net/search/?type_of_search=soft&type_of_search=soft&words=hdparm
>
Mark,

I asked on the SUSE list and was informed by Philipp Thomas of Novell
(cc'ed) that the only mention of make_bad_sector in the hdparm-7.7
source is in a todo list.

Sounds like a useful tool, so I was hoping to encourage suse to
include it with future releases.

Thanks
Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
