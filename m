Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbXESRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbXESRqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbXESRqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:46:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:33063 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbXESRqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ncz06XSt/wz1Zx92ke7VstYJbUgbgDOHkzdUB0plK0biB8BE+pdPQ7kk4KJOytzuhcUc6dxUMvo8YG2BhyP302RmdUV46/nUOFfBXhZeJb+N3G51lfwZCmlIczdLkAhPE7u49otxRy1ZT7Z7brp5/3mmBmINvWSJWg3aPFL3O/k=
Message-ID: <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com>
Date: Sat, 19 May 2007 19:46:27 +0200
From: "oliver pinter" <oliver.pntr@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: it seems at XFS bug?!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pancs:~/kernel# ll
total 460
-rw-r--r-- 1 root root      0 2007-05-19 19:36
-rwxr-xr-x 1 root root    259 2007-05-06 13:14 lspc.sh
-rw-r--r-- 1 root root  92184 2007-05-06 13:06 mypc.txt
-rw-r--r-- 1 root root  91058 2007-05-06 12:42 pc.tct
-rw-r--r-- 1 root root  93834 2007-05-06 12:58 pc.txt
-rw-r--r-- 1 root root 182116 2007-05-06 12:39 tet
-rw-r--r-- 1 root root      0 2007-05-06 12:41

the last line is very interesting, this file has no name and the size is 0 byte.

I have several times booting and using the 2.6.21-git1 .. 2.6.22-rc2 kernels.
And now I use   2.6.21.1.

This error have yet others to happen.

(sorry for the bad spelling, I not learned  english)
