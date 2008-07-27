Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYG0RQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYG0RQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 13:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYG0RQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 13:16:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:10993 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYG0RQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 13:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TATGP+CHxOL0Q5zrrEipFrI/P8pRAw5Kl+uT7ISxJoQe7KYaanb2Qm13vOXuTSL2TZ
         YJs0JJPwT+5MiZ7XvicyS+bMGcYNTn3nTQgV++IAHKD0tby+VlXWzVauH8c200MhbhwM
         huEukojU8093t37O/YZ23TENuVtKOrBXIp074=
Message-ID: <5a4c581d0807271016x2cc136d2ice83613754a524fd@mail.gmail.com>
Date: Sun, 27 Jul 2008 19:16:03 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: www.eu.kernel.org has a bad 2.6.26-git15.bz2 copy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in case some of the kernel.org folks want to take a look...

First one is from eu.kernel.org, second one is from www.kernel.org:

[asuardi@sandman v2.6]$ ls -l patch-2.6.26-git15*
-rw-r--r-- 1 asuardi asuardi 9333206 2008-07-27 19:08 patch-2.6.26-git15.bz2
-rw-r--r-- 1 asuardi asuardi 9333206 2008-07-27 09:01 patch-2.6.26-git15.bz2.1
[asuardi@sandman v2.6]$ md5sum patch-2.6.26-git15*
6f1bb80eeaca5e4772d07116cabd5b2a  patch-2.6.26-git15.bz2
e7e0954872d735515623e77506d65065  patch-2.6.26-git15.bz2.1

The one from eu.kernel.org won't bunzip2 due to a CRC error, of course.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
