Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbXGEISe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbXGEISe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXGEIS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:18:27 -0400
Received: from web52905.mail.re2.yahoo.com ([206.190.49.15]:44701 "HELO
	web52905.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752784AbXGEIS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:18:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fwUb9htx2PBTrrcoHL07PHw4PY06e35d1BweLsy7qamowY1teqwS67rYdiPE9acZfc4JphkY2ASfhXkPiIeyHvBvB2729qN+282RtoACVHKULorRznyAd36z8YyMWj3K2yRKNmiLVYy9pFfBbFWcUEe3yuvxhNLTb5FM8gdwJhU=;
X-YMail-OSG: NkvNXWIVM1lLMlX0CVDHa4..frvwT5D3DS3cfyyP6euvOAuu1sW_aF0t.R2_INHOoFHZGFcnJpYCI3sVMQVqtxKMcW5ukgx_CAMaY_dkBkO3AJzQe2WaeXummaemsl069asLTMsN9uSFcnY-
Date: Thu, 5 Jul 2007 09:18:25 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Libata PATA status
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <438835.62282.qm@web52905.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not. I boot back and forth randomly between old and new IDE kernels
> without problems. The root fs loaded is set in kernel or grub (or on most
> distros nowdays by label scanning from initrd) so just works. Then mount
> label or uuid based mounting does the rest.

You say that, but I remember the "fun" I had upgrading from FC5 to F7 when the installer couldn't
find my swap partition (as described in /etc/fstab). There were also LVM partitions to contend
with, although vgcfgbackup/vgcfgrestore seemed to sort that out nicely enough. And since I have a
PCI SATA card, the SATA drive suddenly became sdb when I switched to PATA too. So it was all very
much a "one way" process, particularly when the userspace applications needed to be re-educated as
well.

I also know of at least one person (who shall remain nameless because he ought to know better) who
is thinking about buying a brand new machine and installing F7 from scratch rather than go through
the pain of upgrading IDE to PATA.

Cheers,
Chris



      ___________________________________________________________ 
Yahoo! Mail is the world's favourite email. Don't settle for less, sign up for
your free account today http://uk.rd.yahoo.com/evt=44106/*http://uk.docs.yahoo.com/mail/winter07.html 
