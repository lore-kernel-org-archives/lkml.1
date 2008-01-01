Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYAAU5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYAAU5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYAAU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:57:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:32483 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbYAAU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:56:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IHPdjA1Hm0JmSojQPv8e8z3ZVdRhDwmeaQhmhAVFO4X952Tj9l4u9YijjZxZ9feLpGGfQsxpzwWMHDLuWeoijW5fAx/Z+cxNLdbK86yCZiODd+8x09oPRaazPHGDNbi2UnOJtsDW38pYdK5lCtusFZf9w9LHF40wvVI/GSG734U=
Message-ID: <60d29d630801011256r300cb0e4l46293ab48ac5b8ed@mail.gmail.com>
Date: Tue, 1 Jan 2008 21:56:59 +0100
From: Abdel <draconux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux 0.01 released
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody and happy new year,


I have ported linux 0.01 to gcc-4.x, and bach-3.2 (and few others
programs) can run on it.

so you will find binary Image of linux 0.01 floppy and qemu hdd here:
http://draconux.free.fr/download/os-dev/linux0.01/Image/

to run it on qemu :
> qemu  -hdb hd_oldlinux.img  -fda linux-0.01-3.3.omg -boot a
nb : also work with bochs, and I have not tested it (yet) on real computer.

----------------

kernel source code :
http://draconux.free.fr/download/os-dev/linux0.01/linux-0.01-rm-3.x/linux-0.01-rm-3.3.tgz

to see change from original linux 0.01 to linux-0.01-3.3 see
- http://draconux.free.fr/download/os-dev/linux0.01/doc/note_patch
- http://draconux.free.fr/download/os-dev/linux0.01/linux-0.01-rm-1.x/patch_*
- http://draconux.free.fr/download/os-dev/linux0.01/linux-0.01-rm-3.x/patch_*
- http://draconux.free.fr/download/os-dev/linux0.01/linux-0.01-rm-2.x/patch_*

doc :
http://draconux.free.fr/download/os-dev/linux0.01/doc/LINUX_0.01_GCC_4.x

----------------

If you have some problem runing linux 0.01 you can mail me :)

regards,

-- 
Abdel Benamrouche
http://draconux.free.fr/
