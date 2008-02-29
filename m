Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYB2Luh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYB2Luh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYB2Lu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:50:27 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:41164 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYB2Lu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=R99Ak2Pup/FhUJRTIOgOOv3ahJkiSX1Pv3LOcH6MJwrsD5Tr1A90/7N5U4IJiC26YJciKJZZ8uVVVh8MwchP3XenrXvUsg9+bORhArsQc7IlIbW54wwAqGiIwD4AdKFibxO0U2y//GCIA5AlTxnCmoeBpTWBlsZNmmZXrULAQA0=
Date: Fri, 29 Feb 2008 12:50:16 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: coding style fixes
Message-ID: <20080229125016.11aa2217@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi (3):
      x86: coding style fixes to arch/x86/lib/usercopy_32.c
      x86: coding style fixes to arch/x86/kernel/early_printk.c
      x86: coding style fixes to x86/kernel/early_printk.c

 arch/x86/kernel/early_printk.c |   24 ++++----
 arch/x86/lib/usercopy_32.c     |  122 ++++++++++++++++++++--------------------
 2 files changed, 73 insertions(+), 73 deletions(-)

