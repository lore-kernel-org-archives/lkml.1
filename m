Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXBVBA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXBVBA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXBVBA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:00:57 -0500
Received: from web63201.mail.re1.yahoo.com ([69.147.97.11]:26265 "HELO
	web63201.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932798AbXBVBA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:00:56 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Feb 2007 20:00:56 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DWAEtW1MspBQ6m1GFqaTNDMXYfXo3rSj4zTYTjT6Z9U9nX54yeKiggdEWZeIWQtQBdy5cZ6A2+vD8qqoqjEWddojyXBWYWvOB/k2ohwIUnyKLpScNxFqmH3xb/NQMFCYD40UBelOCDBAtDnf3nZqQhfRjSTo20Akb9aApgWD7gc=  ;
Message-ID: <20070222005414.4843.qmail@web63201.mail.re1.yahoo.com>
X-YMail-OSG: aptcqNoVM1mTds8QrRUSh_2ReqskxTteqHpqv.X.9j91b0Lo7lSJWXmHsukG8dEodKI5sp2nV4zcueg0qBekDH231l_DxZp8vl.6q4Qsmazn2v5w5P6iMw--
Date: Wed, 21 Feb 2007 16:54:14 -0800 (PST)
From: Brandon Howard <brandon_waldgrave@yahoo.com>
Subject: First desktop motherboard supported by LinuxBIOS: GIGABYTE M57SLI-S4
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The GIGABYTE M57SLI-S4 [1] is the first-ever desktop motherboard
supported by a Free & Open Source BIOS, thanks to AMD engineer Yinghai
Lu who released GPL-licensed code last month. This state-of-the-art
motherboard is based on the NVIDIA nForce 570 SLI chipset and AMD's
latest Socket AM2. It contains tons of advanced features such as:

Support for AMD Athlon 64 X2, Athlon 64 FX and Athlon 64 processors
2X PCI Express x16 slots
3X PCI Express x1 slots
2X PCI slots
3X 1394a (FireWire) ports
10X USB 2.0
16GB maximum memory
SATA RAID
6X SATA 3Gb/s slots.

This motherboard can be obtained today from many retail and online
stores [2] and the source code for the BIOS can be downloaded from the
LinuxBIOS SVN server [3]. 

This is a huge victory in the quest for a completely Free & Open
Source general-purpose computer that enables users to have full
control over their own hardware. The Free Software Foundation has made
the campaign for a Free BIOS a top priority because it is a key
component in the software stack of personal computers [4]. The need
for a Free BIOS is even more pressing since DRM and Treacherous
Computing have found their way into some proprietary BIOSes and EFI.
>From a practical perspective, LinuxBIOS removes the need for ugly
hacks and workarounds in the kernel that compensate for buggy BIOSes –
we can now fix the BIOS ourselves.

I encourage everyone upgrading their desktop computers to consider
getting this motherboard or another one that is supported by
LinuxBIOS.

-Brandon


 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
