Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYHHLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYHHLsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYHHLsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:48:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:9030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYHHLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Ef5Q+mw3wr8W0+X370p8Ttj4vF4XdrG8cKJmRMeqJp2oJDLOVmif6Ac5as4geFpNS1
         /p0xQXH7YzgyFQdP3Crhqj5THgrys2lZ19XOQ12uYs/UPsCVf5+/JU2ZDk7zwRSkfe+f
         6wpqHhHC5afOlpT5Dni0cSSbYfg1WNMjlglEU=
Message-ID: <4170c1720808080448qb94d5beua26a67c89f14a5ce@mail.gmail.com>
Date: Fri, 8 Aug 2008 12:48:00 +0100
From: "john maclean" <jayeola@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Thinkpad ACPI woes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey chaps,

I'm a user and lurking on this list to keep abreast of what you chaps
are upto. Great work and keep it up. However ACPI used to just work on
my IBM Thinkpad x30. I close the lid, open it after some time and I
get X back. Right now it's unpredictable as I never can tell when I'll
get it out of sleep as the screen remains black no matter what keys i
hit. This is with no boot parameters and default "everything" from
distribution maintainers. This is the case ever since the 2.6.25.+
kernel.

Right now uname -r 2.6.25.10-libre.86.fc9.1.i686.

I've seen recommendations
here:-http://www.thinkwiki.org/wiki/Problem_with_display_remaining_black_after_resume.

1) Is anyone else facing this black screen after resume problem? If so
what have you done to correct this?
2) Is this the right location for this message?
3) How much body armour do I need to prepare myself for the barrage of
"GTFO, n00b!"?

-- 
John Maclean - 07739 171 531
MSc (DIC)
