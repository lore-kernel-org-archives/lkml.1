Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXFOAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXFOAhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbXFOAhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:37:10 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1259 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbXFOAhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:37:08 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 17:36:34 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEJBEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <20070615005659.443fdbf5@the-village.bc.nu>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 17:37:12 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 17:37:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Perhaps the FSF will in future remember to pack a copy of the GPL in each
> of its md5sum files on the mirror if this is a derivative work, and
> modify the bittorrent protocol to include a copy of the GPL in the seed
> files 8)
>
> Alan

I realize you're joking, but for the benefit of anyone who might not
understand how this works:

A derivative work must, first and foremost, be a work. If it's not a work,
it's not a derivative work because a derivative work is a type of work.
Aggregations of multiple works, when that aggregation is performed in an
automated way, are not works. Even if I compile and link a bunch of source
code, provided there is no creative input in the compile and link process,
the result is not a work for copyright purposes. It is simply an aggregate
of the bits of source code. The gist of a compilation or derivative work is
the creative selection and modification process.

If someone argues that a program is a derivative work of a header file it
was compiled with, he is probably just being sloppy. The resulting
executable contains the header file combines with other works. Of course, a
source code file that is designed based on the contents of a header file may
be a derivative work of that header file, but that would be because the
human who wrote the source code file used bits of the header file in the
source code itself. It would not be because the compiler combined them --
such an automated combination has no creative input and so cannot produce a
work, and so cannot produce a derivative work.

This is grossly oversimplified, but should give you the idea.

DS


