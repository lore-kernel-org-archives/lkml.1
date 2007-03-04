Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbXCDMun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbXCDMun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXCDMun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:50:43 -0500
Received: from www.osadl.org ([213.239.205.134]:51817 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbXCDMun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:50:43 -0500
Subject: Re: [PATCH] hrtimers: hrtimer_clock_base description typo
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andres Salomon <dilinger@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <45EABF71.3010106@debian.org>
References: <45EABF71.3010106@debian.org>
Content-Type: text/plain
Date: Sun, 04 Mar 2007 13:56:36 +0100
Message-Id: <1173012997.24738.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 07:45 -0500, Andres Salomon wrote:
> The description for the hrtimer_clock_base struct describes
> "hrtimer_base".  That should be hrtimer_clock_base.
> 
> (Resending; forgot to sign off)
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


