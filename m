Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXIZIJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXIZIJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbXIZIJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:09:21 -0400
Received: from gw.leta.ru ([195.28.52.95]:57103 "EHLO gw.leta.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXIZIJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:09:20 -0400
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 04:09:20 EDT
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	NOD32 for Linux Mail Server.
	For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 26 Sep 2007 11:39:12 +0400
From: Pavel Fedin <sonic_amiga@rambler.ru>
X-Mailer: The Bat! (v3.64.01 Christmas Edition) Professional
Reply-To: Pavel Fedin <sonic_amiga@rambler.ru>
X-Priority: 3 (Normal)
Message-ID: <4010187171.20070926113912@rambler.ru>
To: linux-kernel@vger.kernel.org
Subject: NinjaSCSI PCMCIA card
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SpamTest-Version: SMTP-Filter Version 2.0.0 [0138], Confidential/Release
  SMTP-Filter Version 2.0.0 [0124], KAS/Release
X-Spamtest-Info: Pass through
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello!

 Can i get this card working? Hotplug doesn't recognise it, however i
know that Linux supports it. My kernel is relatively new (2.6.11.1).
cartctl info gives this:
 --- cut ---
PRODID_1="            "
PRODID_2="NinjaSCSI Card_"
PRODID_3="Ver 1.00"
PRODID_4="NS00100M"
MANFID=0000,0000
FUNCID=255
 --- cut ---
 I wonder why the hell does it have empty numeric IDs?

-- 
Best regards,
 Pavel                          mailto:sonic_amiga@rambler.ru

