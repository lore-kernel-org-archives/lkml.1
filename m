Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbYFZNhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbYFZNhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763420AbYFZNhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:37:08 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24182 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759638AbYFZNhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:37:05 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com
Subject: Microblaze init port v4
Date: Thu, 26 Jun 2008 14:29:29 +0200
Message-Id: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

current linux version is 2.6.26-rc8 and I think this is the right time
to send latest patches againts rc8 for Microblaze CPU.

I fixed there some issues which were reported to me.

We have there still problem with syscalls and we don't have chance to 
fix it to stable version, this is not part which I can do yourself. 
Microblaze will be n + 1 platform which use some old syscalls. 
I hope you understand.

I am sending more than 50 patches and I would like to see ACKs for patches
which are good and comments for patches which are bad.

Thanks for your time and review.

Best regards,
Michal Simek
www.monstr.eu


