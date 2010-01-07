Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906Ab0AGTgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0AGTgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897Ab0AGTgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:36:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61380 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0AGTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ui8VjdFpaqxMrd0Chovtlkqy0unmOf/08mJmiT/wGbITWhbWcPj9QFN7sP70S4Qnzt
         Ml+TQjG3/aUrcwnVIvdj64ezWaS4FbtlWhgqc87zNB721E8gRM7HgzpflId/wEfZfbwQ
         mkPzXa0uwsscP7P6S+5syiVpncdan3adI/xn4=
MIME-Version: 1.0
Date: Thu, 7 Jan 2010 20:36:31 +0100
Message-ID: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
Subject: [2.6.33-rc3] [WMI?] [RFKILL?] [WIRELESS?] hang: BUG: Unable to handle 
	kernel NULL pointer dereference at 00000008
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       carlos@strangeworlds.co.uk,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.33-rc2
Affected: 2.6.33-rc3

Description:

1. When wireless button enabled system hangs on:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0038.JPG

2. When disable bluetooth and wireless button, I got a bug:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0039.JPG

3. When reboot I have message:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0040.JPG

Config:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/config-2.6.33-rc3

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
