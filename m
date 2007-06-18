Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbXFRUNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbXFRUNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764806AbXFRUMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:12:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:43012 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764409AbXFRUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=or+rTQPl3P2w56qML9CEVSHLJP5YRVQGTbuY0Q614AkpvAgHyCSBDFHdaODSjXkK4l4u37Lyq/xM6LvruORq2qtY80GoT/PFpEgn7Cy9DVlHjJdhvo3SN3ZyrtTyO4UHOuZfIQz3BlYyu9uP+/MwCpvPUgUfOHGziyC4p84snw4=
Message-ID: <4676E707.8020109@googlemail.com>
Date: Mon, 18 Jun 2007 22:11:51 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [ANNOUNCE] Linux Kernel =?UTF-8?B?VGVzdGVy4oCZcyBHdWlkZSB2MC4zLXI=?=
 =?UTF-8?B?YzE=?=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are pleased to announce the availability of "Linux Kernel Tester's Guide" v0.3-rc1.

This short guide describes the basics of kernel testing. The handbook is divided into six chapters:

1 The kernel, patches, trees and compilation
  1.1 The kernel
  1.2 Patches
  1.3 Ketchup
  1.4 Trees
  1.5 The -mm tree
  1.6 Compilation and installation
    1.6.1 Kernel compilation
    1.6.2 Useful make options
    1.6.3 Kernel modules
    1.6.4 Kernel hacking options
    1.6.5 Magic SysRq
    1.6.6 Installation
    1.6.7 Automated conﬁguration and installation
2 Testing
  2.1 Phase One
  2.2 Phase Two (AutoTest)
  2.3 Phase Three
  2.4 Measuring performance
  2.5 Hello world! or What exactly are we looking for?
  2.6 Binary drivers and distribution kernels
3 Collecting kernel messages
  3.1 Syslog, console and dmesg
  3.2 Serial console
  3.3 Network console
4 Git, quilt and binary searching
  4.1  Git
  4.2  Quilt
  4.3  General idea of binary searching
  4.4  Binary searching with the help of quilt
  4.5  Binary searching with the help of git-bisect
  4.6  Caveats
5 Reporting bugs
6 Testing of hardware
A Related topics
  A.1 Test system
  A.2 KLive
  A.3 Sending patches
  A.4 How to become the kernel developer?
B License

PDF version
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf

LaTeX source
http://www.stardust.webpages.pl/files/handbook/handbook-current.tar.bz2

Any comments, suggestions and patches are welcome.

Huge thanks goes to Rafael J. Wysocki who translated the entire guide into English.
This is one of those rare cases when translation is better than original version :).

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
