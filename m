Return-Path: <linux-kernel-owner+w=401wt.eu-S936352AbXHJPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936352AbXHJPu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762648AbXHJPuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:50:14 -0400
Received: from 212-41-248-74.c-wtaubstummengasse.xdsl-line.inode.at ([212.41.248.74]:4078
	"EHLO s.bksys.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760490AbXHJPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:50:13 -0400
Message-ID: <46BC804D.6050804@bksys.at>
Date: Fri, 10 Aug 2007 17:12:13 +0200
From: Bernhard Kuemel <bernhard@bksys.at>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: menuconfig should wrap long lines
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

make menuconfig clips lines which do not fit:

  │   Depends on: !X86_VOYAGER && !X86_NUMAQ && !X86_VISWS &&
!IA64_HP_SIM && (IA64 || X86) &&  │

I was able to view the whole line by making my console window wider,
but that may not always be possible so I think it might be better to
wrap long lines.

Bernhard

PS: I am off the list, but I may check the archives for replies.

-- 
Please encrypt all emails
GPG Key (ID F732FBF3 E4219D48) available on public key servers
Fingerprint E18F BF4D 0EE2 6522 E950  A06A F732 FBF3 E421 9D48
