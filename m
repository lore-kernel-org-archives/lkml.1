Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXCDMvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXCDMvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXCDMvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:51:16 -0500
Received: from www.osadl.org ([213.239.205.134]:53098 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbXCDMvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:51:15 -0500
Subject: Re: [PATCH] hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andres Salomon <dilinger@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <45EABFD1.9010800@debian.org>
References: <45EABFD1.9010800@debian.org>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 13:57:05 +0100
Message-Id: <1173013026.24738.125.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 07:47 -0500, Andres Salomon wrote:
> The description for HRTIMER_CB_IRQSAFE_NO_SOFTIRQ is backwards; "NO
> SOFTIRQ" sounds a whole lot like it means it must not be run in a
> softirq.   :)
> 
> (Resending; forgot to sign off)
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


