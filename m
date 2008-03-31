Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYCaCDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYCaCDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYCaCDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:03:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:10314 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYCaCDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HtUgHX2ZdJF1XoaWcFtnG03H2+TbvhpcEBqrE4BC8FdmPl4sO6oJC3VRWqOdhYH9guR6epcvU6xVldYLougav5/iK5BmFwNE8/fIOWDglFnzGDO9V3jywribNghYhSQ64fQf+J9E/itbDIDERXGFbqeusdxfXoUnrgB091nDx4s=
Message-ID: <47F0491F.4050804@gmail.com>
Date: Mon, 31 Mar 2008 10:14:55 +0800
From: Peter Teoh <htmldeveloper@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: RFC:   Writing Solaris Device Drivers in Java
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting read:

http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf

Personal comments:

Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop 
up - I don't see why it inhibits (in spite of the many initial 
difficulties as mentioned in the paper) the growth of using Java for 
device drivers development.   Contrast it against udev - esp in terms of 
usability/supportability/extensibility etc.   udev is a Linux thing, 
whereas Java is at industry level.   If everyone write applications 
device drivers using Java (minus the extreme hardware arch specific 
stuff, but supports all the low level protocol specific stuff like 
TCP/IP, NFS, USB etc) then I think it has potential to compete against C 
lang - the monopolizer till today in the kernel world 
(Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
the Solaris in Linux, won't it be cool?
