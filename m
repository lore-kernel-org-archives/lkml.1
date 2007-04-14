Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXDNRmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXDNRmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXDNRmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:42:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:57083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXDNRmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=VJEl9h+fMthBHnNNNsFpK6itO13LdbHexH7LYszAbO60bMcshM3kj1Dj71yjdvhDDZCk9ajZiPKL5WMOkZyBTYEdRhNAGfDWQGG8RbEpplPrkkzA4vwzg9He/Mwi942z6pFzlZmE4FbHe+/MDDhQ5gAUiwJbCSX6D3XU6+MBXa4=
Message-ID: <462111F8.1060700@gmail.com>
Date: Sat, 14 Apr 2007 21:40:08 +0400
From: Ignatich <ignatich@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You might want to look at this discussion:
http://mail.opensolaris.org/pipermail/zfs-discuss/2007-April/027041.html

Let me quote my last letter:
The problem is not with CDDL, GPL is the problem. ATI and nVidia do 
provide binary modules with GPL "adapters", but I don't think legality 
of this approach was proven in court. I see no parties interested in 
proving that it is not legal (Intel perhaps?), but Sun is another story. 
They are not interested in ZFS port for Linux, because Solaris and Linux 
are real competitors, and if winds change may decide to take legal 
action. Also, such port can never be included in mainline for obvious 
reasons and I really want to see storage system such as ZFS as "default" 
for Linux in future. To sum all of this I see a number of possible 
solutions for this situation:

1. Sun dual licenses ZFS as GPLv2 and thus gives green light for 
ZFS-Linux port. Personally I doubt that this will happen.

2. Linux changes it's license. The chance is near zero.

3. US and EU courts clearly state that it is legal to use non-GPL kernel 
modules in Linux.

4. GPL ZFS reimplementation project is started. I prefer that way until 
1), 2) or 3) happen.

I know Sun opened most if not all ZFS related patents for OpenSolaris 
community. So I repeat questions I asked in my first mail:

1. Are those patents limited to CDDL/OpenSolaris code or can by used in 
GPL/Linux too?

2. If GPL code can't use those patented algorithms, will you please 
provide list of ZFS-related patents? RAID-Z and LZJB are most obvious 
technologies which may be patent protected.
<end>

So far I've got no response from Sun. According to Jeff Bonwick's blog 
Sun issued 56 patents on ZFS, but I have no idea what they patented. 
Sorry, binary compatible ZFS reimplementation with GPL license might not 
be legal. If you know something about this or can help to get ZFS 
related patent list please send me a mail.

Sincerely yours, Max V. Yudin
