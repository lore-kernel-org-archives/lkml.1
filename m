Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYIXKgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYIXKgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIXKge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:36:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:54428 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYIXKgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=g3c4JfzEVAKnVSqINnbsr4G61Krvf36Jcv/+DA+7IcDFQFileBPpmFeBFyGsvfI565
         H98Z2p6PHYgUYwkiuMcIq1ArDwUw+CoXMblWSGM9AGJjNqKDScrE4H5OUq7hww9I72EA
         aYf3TFi2Mu7h30aCrb4GL1+1EBNvhagATFG6w=
From: Sylwester Gruszka <gruszex@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Broken XFS partition
Date: Wed, 24 Sep 2008 12:36:25 +0200
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200809241236.26135.gruszex@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a problem with XFS partition, it has broken down suddenly. I was doing 
no special things, just browsing www and suddenly my PC has restarted, after 
that I could not boot by PLD Th linux, after few usual kernel messages I get 
some matrix of numbers and it stops.

I realised that it is broken partition after I tried to repair system, I just 
could not mount this partition (using sysrescuecd), 'mount' gave me lots of 
weird numbers instead of mounting partition. It only do that way at first try, 
the second try always freezes mount program and nothing is happening.

Here are some screenshots (mount using SystemRescueCd-1.1.0 so the kernel is 
propably 2.6.25.16):
http://img397.imageshack.us/my.php?image=dsc01043ko6.jpg
http://img179.imageshack.us/my.php?image=dsc01044yj4.jpg
http://img158.imageshack.us/my.php?image=dsc01045sr3.jpg
http://img221.imageshack.us/my.php?image=dsc01047js4.jpg

PLD Linux Th booting:
http://img530.imageshack.us/my.php?image=dsc01048mk3.jpg

Suse booting:
http://img87.imageshack.us/my.php?image=dsc01050as4.jpg
Except this warning it boots normal.

Now I'm running Suse and I tried xfs_check this partition but xfs_check is 
freezing too.

Somebody on PLD Linux mailing list told me to mail this problem here.

I'm nod subscribed to this list so please send me CC.

--
greets,
Sylwester Gruszka
