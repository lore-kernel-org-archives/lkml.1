Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYKIK7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYKIK7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYKIK7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:59:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:56544 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYKIK7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:59:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=Ye880/Yg9JYhdFIatUXb6YTLGWvkP4bhD3Jhgs0BXD/DdkEWPmNdejHdF0QgGr/iMO
         yqab1dbxCeA8qKvLMG6WgvDq/DijUSCuEAoxDcJYFrsp+PrEqaRxNPcNKfXQIHx6PkRr
         53n0qysBRwuoxS/h7ahZdadJPOB6jXbNTlloY=
User-Agent: quilt/0.46-1
Date: Sun, 09 Nov 2008 13:57:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/2] -tip/master apic related cleanup
Message-ID: <4916c290.0407560a.7351.3124@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of

commit dda51106620c328b50007c259b9ef8cea2b7c3d2
Merge: 3391961... a376f30...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 31 11:03:54 2008 +0100

    Merge branch 'x86/cleanups'

Please review. Nothing really serious. Some cleanup work
is still in progress. io_apic.c is not touched since Yinghai
is working on dyn_irq's.

		- Cyrill -
-- 
