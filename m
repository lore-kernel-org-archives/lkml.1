Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbXGZSy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbXGZSy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbXGZSyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:54:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:20037 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbXGZSyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gLWRmWOMkllJvtJNI8lfkVNz+UZxj55q1/uzxZDDWN4im2/sLjiEaUJ2z5RAktIOuNygiY2/ioe+Ia6nCPDWosc7QTQujL4wEKy8PfPPd26Zgs4KPmAkoXf4ngC3z6DtSwE93EUI29WpXHEctMCF4hSYKOEqLTKZB8DEIkXzuWU=
Message-ID: <6101e8c40707261154v5d2b839dpf09c0f53916cbab5@mail.gmail.com>
Date: Thu, 26 Jul 2007 20:54:48 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: [GIT PATCH 00/02] Kconfig cosmetics
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In this little patch is cosmetic in i386 and x86_64 Kconfig files.
In first patch add the "Pentium D" and CPU core name  for help, in
second patch change the order, that logically simplifier when the
cpu-s sorted by
time-line.

01_add_cpu_names_to_kconfig_cpu.patch:
 arch/i386/Kconfig.cpu |   34 +++++++++++++++++++++++++++++++---
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 34 insertions(+), 6 deletions(-)

02_change_order_in_i386_Kconfig_cpu.patch
 arch/i386/Kconfig.cpu |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

-- 
Thanks,
Oliver
