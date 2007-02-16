Return-Path: <linux-kernel-owner+w=401wt.eu-S1946232AbXBPTXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946232AbXBPTXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946240AbXBPTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:23:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:36633 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946239AbXBPTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Nk9HdvOjCdR83BWPw9gvg0yuFYkg84xQ/JnnbDKRNL8HypoNeR+joVeZg1FU50mzrIPIrHKXeZ/O2gm6n8avt2viYqNT/iDEJ0MOK2BzJylEx1hoW6YlqAMgDAOitkRnqBPDfXiS6dSpHy8RmSaH/H39JBADPvF2OxCnDlnUXAY=
Message-ID: <6bffcb0e0702161123n7139afb5sd10431a160b60976@mail.gmail.com>
Date: Fri, 16 Feb 2007 20:23:00 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [QUESTION] parallel console configuration
Cc: linux-parport@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to setup a parallel console.

CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y

kernel params
console=lp0 console=tty0

System stuck on
lp0: using parport0 (interrupt-driven).

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20/00001.jpg

What am I doing wrong?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
