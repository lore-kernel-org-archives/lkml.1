Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbXBPQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbXBPQcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932476AbXBPQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:32:16 -0500
Received: from pool-72-92-185-191.albyny.east.verizon.net ([72.92.185.191]:50678
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932457AbXBPQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:32:15 -0500
X-Greylist: delayed 2074 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 11:32:15 EST
Message-ID: <45D5DC8D.7010609@tmr.com>
Date: Fri, 16 Feb 2007 11:32:13 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: [2.6.20-get13] KVM-12 won't build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Goes out with an error message:

    cc -I /home/davidsen/downloads/kernel.org/linux-2.6.20-git13/include -MMD -MF ./.kvmctl.d -g   -c -o kvmctl.o kvmctl.c
    kvmctl.c:29:2: error: #error libkvm: userspace and kernel version mismatch
    make[1]: *** [kvmctl.o] Error 1
      

I don't see a kvm-13 on the KVM website.

-- 
Bill Davidsen
  He was a full-time professional cat, not some moonlighting
ferret or weasel. He knew about these things.

