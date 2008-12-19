Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYLSTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYLSTbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYLSTbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:31:20 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:59001 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYLSTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pwC40r8jTDD89VbNcGPNEJ9GJVUkgcklnIFwwdknJInJ7JiHStQ94NbKvLtkES2jO8
         468Ib7Y5NRq/i/k249s2HNXev6lUvZDJ0qOeEHSHwzKzQ4wyTJmlsmEuMjaocBDw85NT
         7BVI9MVYuWchv8zma+Xsp3scyuPGC9ZtVOv0U=
Message-ID: <3f9a31f40812191131m48802157r596d7773fb435f34@mail.gmail.com>
Date: Sat, 20 Dec 2008 01:01:17 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, "Jeff Garzik" <jeff@garzik.org>,
       "David Woodhouse" <dwmw2@infradead.org>, sfr@canb.auug.org.au
Subject: Firmware patches for Network
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have 10 pending patches of firmware for Networking available at
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=shortlog :

1. firmware: convert e100 driver to request_firmware()

2. firmware: convert acenic driver to request_firmware()

3. firmware: convert tg3 driver to request_firmware()

4. starfire: use request_firmware()

5. myri_sbus: use request_firmware

6. tehuti: use request_firmware

7. typhoon: use request_firmware

8. smc91c92_cs: use request_firmware

9. yam: use request_firmware

10. 3C359: use request_firmware

Please let me know, should I update these patches for :
1. git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
OR
2. git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
OR
3. git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
OR
4. git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

Thank you,

Jaswinder Singh
