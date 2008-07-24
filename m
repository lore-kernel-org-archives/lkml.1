Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYGXLZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYGXLZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGXLZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:25:39 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:49165 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbYGXLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=Hrh/pzoWvtBSyTIW8tkJBLAQ5RNP2c8jwquz36H6O/UbYJ2LMSaiTod1gcu99C3fHn
         dOeRaHCJhXNfuvq52M6NSgaHSmBjWOcjGhHnR6xEpcHhoO/LhQX1NcmceAFWh1dMEcoR
         S1WcDFUeGths1lQuTEKTUa4mGX2eJWufjcLrs=
User-Agent: quilt/0.46-1
Date: Thu, 24 Jul 2008 15:22:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
Cc: gorcunov@gmail.com
Subject: [patch 0/2] x86 apic - a few function merge
Message-ID: <488866b0.1636440a.2c8e.ffffa15c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I don't leave hope to merge APIC code someday (now it becomes harder
'cause of new x(2)APIC code). So these patches merges a few functions.
No changes on binary level. Please review. Any comments are welcome!

  The patches are made on top of -tip tree

commit d55ee73e46e89547aca7ca83a2df80bf70d9d1d1
Merge: 6a807a0... 695a6b4...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 23 13:21:26 2008 +0200

    Merge branch 'cpus4096'

		- Cyrill -
-- 
