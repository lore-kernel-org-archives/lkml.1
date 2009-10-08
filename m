Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZJHNii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZJHNii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZJHNii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:38:38 -0400
Received: from cmsout01.mbox.net ([165.212.64.31]:49065 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbZJHNih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:38:37 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 09:38:37 EDT
X-USANET-Source: 165.212.11.132  IN   ojbyer@usa.net cmsapps03.cms.usa.net
X-USANET-MsgId: XID942NJHNG16702X01
X-USANET-Auth: 165.212.8.12    AUTO ojbyer@usa.net cmsweb12.cms.usa.net
Date: Thu, 08 Oct 2009 08:32:50 -0500
From: "Jack Byer" <ojbyer@usa.net>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: iso9660 mount problem
CC: <linux-kernel@vger.kernel.org>
X-Mailer: USANET web-mailer (C8.MAIN.3.56O)
Mime-Version: 1.0
Message-ID: <645NJHNfY3626S12.1255008770@cmsweb12.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Z-USANET-MsgId: XID393NJHNGY0272X39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>So it must be an apple hfs disc, (or hybrid disc?).
>Maybe you may try mount it as hfs, this problem is not relevant to iso9660.

I have tested this disc on my Windows XP machine at work and it has no
problems reading it. The program supports Windows and OS X so it is probably a
hybrid disc. I can try mounting as hfs at home tonight as well as extracting
the rest of the metadata.

If I am able to mount as hfs I don't know how much good that will do unless it
is possible to run OS X programs under linux.


