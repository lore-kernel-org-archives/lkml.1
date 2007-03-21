Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXCUWbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXCUWbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933898AbXCUWbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:31:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37471 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897AbXCUWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:31:51 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 21 Mar 2007 18:27:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Arnd Bergmann <arnd@arndb.de>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: remove-unused-header-file-include-linux-elfnoteh.patch
In-Reply-To: <200703212320.35920.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0703211825110.4746@CPE00045a9c397f-CM001225dbafb6>
References: <4601A56A.40609@goop.org> <200703212320.35920.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-442325719-1174516025=:4746"
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-442325719-1174516025=:4746
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 21 Mar 2007, Arnd Bergmann wrote:

> On Wednesday 21 March 2007 22:36:42 Jeremy Fitzhardinge wrote:
> > Please don't.  We need it.
> >
> > BTW, I didn't see this one go by, and I couldn't see it searching
> > around.  Did it get posted to lkml?
>
> I think it was only on the janitor list. It was considered
> obviously correct since it does not get installed by
> headers_installed and did not seem to be used anywhere in
> the kernel.
>
> Could you explain how this file is used in the kernel? Robert
> probably wants to update his script to handle this correctly.

i doubt that this is going to make any difference to my script.  that
header file is, AFAICT, not included by any other file in the entire
source tree -- a simple "grep" will demonstrate that.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
--0-442325719-1174516025=:4746--
