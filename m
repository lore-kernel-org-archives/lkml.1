Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbXGVXk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbXGVXk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbXGVXkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:40:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:2761 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbXGVXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D4kQHvpBTq0qUacZKsS6WDKGqDiKJnmn7BCwQG5MiaNke5d7OKMAJMa2z+//W98bc4IDXRHONCuhYabrHMQXQdu+1+c6LkBAPhWPi0FlcEevndyzJ3ph3LWq1B6hEzDwXmX15MLxRFTTST34Ym6K+dCSINcX7hndct/ErR8HHBE=
Message-ID: <6101e8c40707221640xaa164a2xd539cce1e0e0b698@mail.gmail.com>
Date: Mon, 23 Jul 2007 01:40:47 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE][GIT PATCH 00/02 ] Kconfig.cpu cosmetics (resend)
Cc: "Andi Kleen" <andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In this little patch is cosmetic in i386 and x86_64 Kconfig files.
In first patch add the "Pentium D" for help, in second patch change
the order, that logically simplifier when the cpu-s sorted by
time-line.

01_add_pentium_d_for_kconfig_cpu.patch
02_change_cpu_order_in_Kconfig_cpu.patch

 arch/i386/Kconfig.cpu |   18 +++++++++---------
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
Thanks,
Oliver
