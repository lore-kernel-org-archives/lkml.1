Return-Path: <linux-kernel-owner+w=401wt.eu-S1763067AbYFGP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763067AbYFGP5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbYFGP4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:56:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYFGP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=eZcoSSaAD88Lw8eJqMdli5JdlPnoa/214ohZisNoxxjR8saAKOTW1xhIePYzfJ/yPr
         LKwzOXAJcOCZv4r3xJPlg6HuA8faPw/AAc/sLEh63TAd1rrslC5ibxtIW85LD9AsZeXi
         TjPBbUCveNBPWGRxBGVU9RfjUnWdI4j7+Buwk=
User-Agent: quilt/0.46-1
Date: Sat, 07 Jun 2008 19:53:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 0/2] x86: io-apic cleanup
Message-ID: <484aafbf.0407560a.301e.6a8c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series doesn't introduce any functional change but
attempts to get rid of few hard-coded numbers in io-apic code.

Please review. Any comments are appreciated.

		- Cyrill -
-- 
