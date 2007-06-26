Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXFZTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXFZTKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbXFZTKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:10:35 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4059 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbXFZTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:10:34 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Tue, 26 Jun 2007 12:10:16 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEDGEOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <or8xa64p4h.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 26 Jun 2007 12:10:23 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 26 Jun 2007 12:10:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexandre Oliva:

> On Jun 26, 2007, Al Boldi <a1426z@gawab.com> wrote:
>
> > I read your scenario of the vendor not giving you the source to
> > mean: not
> > directly; i.e.  they could give you a third-party download link.
>
> This has never been enough to comply with GPLv2.

A lot of people seem to say this, but I don't think it's true. Section 3b
says:

    Accompany it with a written offer, valid for at least three
    years, to give any third party, for a charge no more than your
    cost of physically performing source distribution, a complete
    machine-readable copy of the corresponding source code, to be
    distributed under the terms of Sections 1 and 2 above on a medium
    customarily used for software interchange; or,

A web page with a download URL is just such an offer. The Internet is a
medium customarily used for software interchange. I do not see why the
following statement doesn't meet the requirements above:

"The source code for this product is available under the terms of the GPL
from the following web page http://www.mycompanyname.com/gpl"

This assumes that no special steps are needed to obtain the software from
that web page.

DS


