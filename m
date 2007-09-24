Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbXIXLsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbXIXLsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXIXLsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:48:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:65136 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXIXLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dl5ZjfGpiWacgKV4sEdl2TUxqTfBYDHqt0PJWzZiJvLs7xUvnutSsJL0Fldgi01ucStLvOf+FMUUI2YYJDxgpSA06IExKswuiVfRLpDR8QKfMCOXkLg2/pyPkgCxdqD/0KyQBDaiXrS5auGgKUueoNx+yVHZVR0UK9fYGtreuCU=
Message-ID: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>
Date: Mon, 24 Sep 2007 17:18:01 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: realtime preemption performance difference
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I want to check performance difference by using realtime preemption patch :

http://www.kernel.org/pub/linux/kernel/projects/rt/

Please let me know from where I can download samples to test realtime
preemption performance difference.

Can someone please share performance numbers for your hardware:-

1. Interrupt latency
2. Task switching time
3. hard-realtime scheduling latency

Thank you,

Jaswinder Singh.
