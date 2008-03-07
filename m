Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYCGSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYCGSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYCGSZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:25:12 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:34091 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYCGSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Q33trxvUFVQif5/SjGiEpNPdiYEuxSLZ6iWkz/eBUkiE0zsrWfRK3uU+B0fLddWhZ8p0cupqajEpOXmN8s/NyzaHPunr9SfUkME/XYr6nt/CdjPOJaza14I96z0SiBU4z+N+BFJ7xXoDC3+EptNOcyeEpJihXTsvqJ0vqFZcOz8=
Date: Fri, 7 Mar 2008 19:24:59 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86: coding style fixes to arch/x86/kernel/setup_32.c
Message-ID: <20080307192459.52c0a330@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested, patch #2 depends on #1

Paolo Ciarrocchi (2):
      x86: coding style fixes to arch/x86/kernel/setup_32.c
      x86: coding style fixes to arch/x86/kernel/setup_32.c

 arch/x86/kernel/setup_32.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)


Ciao,
                   Paolo
